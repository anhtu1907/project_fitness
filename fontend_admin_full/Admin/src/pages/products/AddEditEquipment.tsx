import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

const initialState = {
  size: "",
  color: "",
  gender: "",
  productId: "",
};

const AddEditEquipment = () => {
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
      api.get(`/api/equipment/${id}`).then((res: any) => {
        const data = res.data.data;
        setForm({
          size: data.size?.toString() || "",
          color: data.color || "",
          gender: data.gender || "",
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
    if (!form.color) newErrors.color = "Color is required";
    if (!form.gender) newErrors.gender = "Gender is required";
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
      color: form.color,
      gender: form.gender,
      productId: Number(form.productId),
    };

    try {
      if (isEdit && id) {
        await api.update(`/api/equipment/${id}`, payload);
      } else {
        await api.create("/api/equipment/create", payload);
      }
      navigate("/admin/product/equipments");
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
        title={isEdit ? "Edit Equipment" : "Add Equipment"}
        name={isEdit ? "Edit Equipment" : "Add Equipment"}
        breadCrumbItems={["Fitmate", "Equipments", isEdit ? "Edit Equipment" : "Add Equipment"]}
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
            <label className="block font-medium mb-1">Color</label>
            <input
              type="text"
              name="color"
              className="form-input w-full"
              value={form.color}
              onChange={handleChange}
            />
            {errors.color && <div className="text-red-500">{errors.color}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Gender</label>
            <select
              name="gender"
              className="form-input w-full"
              value={form.gender}
              onChange={handleChange}
            >
              <option value="">-- Select Gender --</option>
              <option value="men">Men</option>
              <option value="women">Women</option>
              <option value="unisex">Unisex</option>
            </select>
            {errors.gender && <div className="text-red-500">{errors.gender}</div>}
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
              onClick={() => navigate("/admin/product/equipments")}
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

export default AddEditEquipment;