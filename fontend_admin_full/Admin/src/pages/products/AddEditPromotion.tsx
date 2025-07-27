import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import Select from "react-select";
import { toast } from "react-hot-toast";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type FormState = {
  name: string;
  discount: string;
  startDate: string;
  endDate: string;
  usageLimit: string;
};

const initialState: FormState = {
  name: "",
  discount: "",
  startDate: "",
  endDate: "",
  usageLimit: "",
};

const AddEditPromotion = () => {
  const [form, setForm] = useState<FormState>(initialState);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [loading, setLoading] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [products, setProducts] = useState<any[]>([]);
  const [selectedProducts, setSelectedProducts] = useState<any[]>([]);
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [productRes, promoRes] = id
          ? await Promise.all([
              api.get("/api/product"),
              api.get(`/api/promotion/${id}`),
            ])
          : [await api.get("/api/product"), null];

        const allProducts = productRes.data?.data ?? productRes.data ?? [];
        setProducts(allProducts);

        if (promoRes) {
          const data = promoRes.data.data;
          const productDTOs = data.products ?? [];

          setForm({
            name: data.name ?? "",
            discount: data.discount?.toString() ?? "",
            startDate: toInputDate(data.startDate),
            endDate: toInputDate(data.endDate),
            usageLimit: data.usageLimit?.toString() ?? "",
          });

          const selected = productDTOs.map((dto: any) => {
            const fullProduct = allProducts.find((p: any) => p.id === dto.productId);
            return {
              ...fullProduct,
              promotion: {
                discountOverride: dto.discountOverride,
                startDate: dto.startDate,
                endDate: dto.endDate,
              },
            };
          });

          setSelectedProducts(selected);
          setIsEdit(true);
        }
      } catch (err) {
        console.error("Error loading data:", err);
      }
    };

    fetchData();
  }, [id]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleProductSelect = (selected: any) => {
    const ids = (selected ?? []).map((opt: any) => Number(opt.value));
    const selectedItems = products
      .filter((p: any) => ids.includes(p.id))
      .map((p: any) => ({
        ...p,
        promotion: {
          discountOverride: null,
          startDate: null,
          endDate: null,
        },
      }));
    setSelectedProducts(selectedItems);
  };

  const validate = () => {
    const newErrors: { [key: string]: string } = {};
    if (!form.name) newErrors.name = "Name is required";
    if (form.discount === "" || isNaN(Number(form.discount))) {
      newErrors.discount = "Discount is required";
    }
    if (!form.startDate) newErrors.startDate = "Start date is required";
    if (!form.endDate) newErrors.endDate = "End date is required";
    if (!form.usageLimit || isNaN(Number(form.usageLimit))) {
      newErrors.usageLimit = "Usage limit is required";
    } else if (Number(form.usageLimit) < 1 || Number(form.usageLimit) > 999) {
      newErrors.usageLimit = "Usage limit must be between 1 and 999";
    }
    return newErrors;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const errs = validate();
    if (Object.keys(errs).length > 0) {
      setErrors(errs);
      return;
    }
    setLoading(true);

    const start = new Date(`${form.startDate}T00:00:00Z`);
    const end = new Date(`${form.endDate}T00:00:00Z`);

    const payload = {
      name: form.name,
      discount: Number(form.discount),
      startDate: start.toISOString(),
      endDate: end.toISOString(),
      usageLimit: Number(form.usageLimit),
      productIds: selectedProducts.map((p) => p.id),
    };
    console.log("Submitting payload:", payload);
    try {
      let result;
      if (isEdit && id) {
        result = await api.update(`/api/promotion/${id}`, payload);
      } else {
        result = await api.create("/api/promotion/create", payload);
      }

      if (result?.data?.success === false) {
        const apiErrors = result?.data?.errors;
        if (apiErrors?.Exception) {
          setErrors({ submit: apiErrors.Exception });
        } else {
          setErrors(apiErrors);
        }
        toast.error(result?.data?.message || "Validation error");
        setLoading(false);
        return;
      }

      toast.success(isEdit ? "Promotion updated successfully!" : "Promotion created successfully!");
      navigate("/admin/product/promotions");
    } catch (err: any) {
      const apiErrors =
        err?.response?.data?.errors || err?.data?.errors || {};
      if (apiErrors.Exception) {
        setErrors({ submit: apiErrors.Exception });
      } else {
        setErrors(apiErrors);
      }
      toast.error("Failed to save promotion!");
    } finally {
      setLoading(false);
    }
  };

  const productOptions = products.map((p: any) => ({
    value: p.id,
    label: p.name,
  }));

  return (
    <>
      <PageBreadcrumb
        title={isEdit ? "Edit Promotion" : "Add Promotion"}
        name={isEdit ? "Edit Promotion" : "Add Promotion"}
        breadCrumbItems={["Fitmate", "Promotions", isEdit ? "Edit Promotion" : "Add Promotion"]}
      />
      <div className="col-span-12 mx-auto">
        <form className="card p-8 col-span-12 space-y-6" onSubmit={handleSubmit}>
          {errors.submit && <div className="text-red-500 mb-2">{errors.submit}</div>}

          <div>
            <label className="block font-medium mb-1">Name</label>
            <input
              type="text"
              name="name"
              className={`form-input w-full ${errors.name ? "border-red-500" : ""}`}
              value={form.name}
              onChange={handleChange}
            />
            {errors.name && <div className="text-red-500 text-sm mt-1">{errors.name}</div>}
          </div>

          <div>
            <label className="block font-medium mb-1">Discount (%)</label>
            <input
              type="number"
              name="discount"
              className={`form-input w-full ${errors.discount ? "border-red-500" : ""}`}
              value={form.discount}
              onChange={handleChange}
              min={0}
              max={1}
              step={0.01}
              placeholder="0.2 = 20%"
            />
            {errors.discount && <div className="text-red-500 text-sm mt-1">{errors.discount}</div>}
          </div>

          <div>
            <label className="block font-medium mb-1">Start Date</label>
            <input
              type="date"
              name="startDate"
              className={`form-input w-full ${errors.startDate ? "border-red-500" : ""}`}
              value={form.startDate}
              onChange={handleChange}
            />
            {errors.startDate && <div className="text-red-500 text-sm mt-1">{errors.startDate}</div>}
          </div>

          <div>
            <label className="block font-medium mb-1">End Date</label>
            <input
              type="date"
              name="endDate"
              className={`form-input w-full ${errors.endDate ? "border-red-500" : ""}`}
              value={form.endDate}
              onChange={handleChange}
            />
            {errors.endDate && <div className="text-red-500 text-sm mt-1">{errors.endDate}</div>}
          </div>

          <div>
            <label className="block font-medium mb-1">Usage Limit</label>
            <input
              type="number"
              name="usageLimit"
              className={`form-input w-full ${errors.usageLimit ? "border-red-500" : ""}`}
              value={form.usageLimit}
              onChange={handleChange}
              min={1}
              max={999}
            />
            {errors.usageLimit && (
              <div className="text-red-500 text-sm mt-1">{errors.usageLimit}</div>
            )}
          </div>

          <div>
            <label className="block font-medium mb-1">Products</label>
            <Select
              options={productOptions}
              value={productOptions.filter((opt) =>
                selectedProducts.some((p: any) => p.id === opt.value)
              )}
              onChange={handleProductSelect}
              isMulti
              placeholder="Select products for this promotion"
              classNamePrefix={errors.productIds ? "border-red-500" : ""}
            />
          </div>

          {selectedProducts.length > 0 && (
            <div className="mt-4 overflow-x-auto">
              <table className="min-w-full border">
                <thead>
                  <tr className="bg-gray-100">
                    <th className="p-2 border">ID</th>
                    <th className="p-2 border">Image</th>
                    <th className="p-2 border">Name</th>
                    <th className="p-2 border">Price</th>
                    <th className="p-2 border">Discount Override</th>
                    <th className="p-2 border">Promotion Start</th>
                    <th className="p-2 border">Promotion End</th>
                    <th className="p-2 border">Stock</th>
                  </tr>
                </thead>
                <tbody>
                  {selectedProducts.map((p: any) => (
                    <tr key={p.id}>
                      <td className="p-2 border">{p.id}</td>
                      <td className="p-2 border">
                        {p.image ? (
                          <img
                            src={
                              p.image.startsWith("http")
                                ? p.image
                                : `${BASE_URL}/resources/${p.image}`
                            }
                            alt={p.name}
                            style={{ width: 60, height: 60, objectFit: "cover", borderRadius: 8 }}
                          />
                        ) : (
                          <span className="text-gray-400">No Image</span>
                        )}
                      </td>
                      <td className="p-2 border">{p.name}</td>
                      <td className="p-2 border">{p.price}</td>
                      <td className="p-2 border">{p.promotion?.discountOverride ?? "-"}</td>
                      <td className="p-2 border">
                        {p.promotion?.startDate
                          ? toInputDate(p.promotion.startDate)
                          : "-"}
                      </td>
                      <td className="p-2 border">
                        {p.promotion?.endDate
                          ?toInputDate(p.promotion.endDate)
                          : "-"}
                      </td>
                      <td className="p-2 border">{p.stock}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          <div className="flex justify-end gap-2">
            <button
              type="button"
              className="btn bg-gray-200 text-gray-700"
              onClick={() => navigate("/admin/product/promotions")}
              disabled={loading}
            >
              Cancel
            </button>
            <button type="submit" className="btn bg-primary text-white" disabled={loading}>
              {loading ? "Saving..." : isEdit ? "Update" : "Save"}
            </button>
          </div>
        </form>
      </div>
    </>
  );
};

export default AddEditPromotion;

function toInputDate(v?: number | string) {
  if (!v) return "";
  const seconds = typeof v === "string" ? parseInt(v, 10) : v;
  const d = new Date(seconds * 1000); 
  return isNaN(d.getTime()) ? "" : d.toISOString().slice(0, 10);
}
