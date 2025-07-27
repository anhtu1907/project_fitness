import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

const initialState = {
  size: "",
  ingredient: "",
  productId: "",
};

const AddEditSupplement = () => {
  const [form, setForm] = useState(initialState);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [loading, setLoading] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [products, setProducts] = useState<any[]>([]);
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();

  useEffect(() => {
    fetchProducts();
    if (id) {
      setIsEdit(true);
      api.get(`/api/supplement/${id}`).then((res: any) => {
        const data = res.data.data;
        setForm({
          size: data.size?.toString() || "",
          ingredient: data.ingredient || "",
          productId: data.product?.id?.toString() || "",
        });
      });
    }
  }, [id]);

  const fetchProducts = async () => {
    const res = await api.get("/api/product");
    setProducts(res.data.data || []);
  };

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const validate = () => {
    const newErrors: { [key: string]: string } = {};
    if (!form.size) newErrors.size = "Size is required";
    if (!form.ingredient) newErrors.ingredient = "Ingredient is required";
    if (!form.productId) newErrors.productId = "Product is required";
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
    const payload = {
      size: Number(form.size),
      ingredient: form.ingredient,
      productId: Number(form.productId),
    };

    try {
      if (isEdit && id) {
        await api.update(`/api/supplement/${id}`, payload);
      } else {
        await api.create("/api/supplement/create", payload);
      }
      navigate("/admin/product/supplements");
    } catch (err: any) {
      if (err?.response?.data?.errors) {
        setErrors(err.response.data.errors);
      } else {
        setErrors({ submit: err?.response?.data?.message || "Save failed" });
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        title={isEdit ? "Edit Supplement" : "Add Supplement"}
        name={isEdit ? "Edit Supplement" : "Add Supplement"}
        breadCrumbItems={["Fitmate", "Supplements", isEdit ? "Edit Supplement" : "Add Supplement"]}
      />
      <div className="col-span-12 mx-auto">
        <form
          className="card p-8 col-span-12 space-y-6"
          onSubmit={handleSubmit}
        >
          {errors.submit && <div className="text-red-500">{errors.submit}</div>}
          <div>
            <label className="block font-medium mb-1">Size</label>
            <input
              type="number"
              name="size"
              className="form-input w-full"
              value={form.size}
              onChange={handleChange}
            />
            {errors.size && <div className="text-red-500">{errors.size}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Ingredient</label>
            <input
              type="text"
              name="ingredient"
              className="form-input w-full"
              value={form.ingredient}
              onChange={handleChange}
            />
            {errors.ingredient && <div className="text-red-500">{errors.ingredient}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Product</label>
            <select
              name="productId"
              className="form-input w-full"
              value={form.productId}
              onChange={handleChange}
            >
              <option value="">-- Select Product --</option>
              {products.map((p: any) => (
                <option key={p.id} value={p.id}>
                  {p.name}
                </option>
              ))}
            </select>
            {errors.productId && <div className="text-red-500">{errors.productId}</div>}
          </div>
          <div className="flex justify-end gap-2">
            <button
              type="button"
              className="btn bg-gray-200 text-gray-700"
              onClick={() => navigate("/admin/product/supplements")}
              disabled={loading}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn bg-primary text-white"
              disabled={loading}
            >
              {loading ? (isEdit ? "Saving..." : "Saving...") : (isEdit ? "Update" : "Save")}
            </button>
          </div>
        </form>
      </div>
    </>
  );
};

export default AddEditSupplement;