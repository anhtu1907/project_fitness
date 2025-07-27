import React, { useEffect, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const IMAGE_BASE_URL = BASE_URL + "/resources/";

const api = new APICore();

const initialState = {
  name: "",
  type: "",
  contact: "",
  address: "",
  image: null as File | null,
};

const AddEditSupplier = () => {
  const [form, setForm] = useState(initialState);
  const [preview, setPreview] = useState<string | null>(null);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [loading, setLoading] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (id) {
      setIsEdit(true);
      api.get(`/api/supplier/${id}`).then((res: any) => {
        const data = res.data.data;
        setForm({
          name: data.name || "",
          type: data.type || "",
          contact: data.contact || "",
          address: data.address || "",
          image: null,
        });
        if (data.image) {
          setPreview(`${IMAGE_BASE_URL}${data.image}`);
        }
      });
    }
  }, [id]);

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value, type } = e.target;
    if (type === "file") {
      const file = (e.target as HTMLInputElement).files?.[0] || null;
      setForm((prev) => ({ ...prev, image: file }));
      if (file) setPreview(URL.createObjectURL(file));
    } else {
      setForm((prev) => ({ ...prev, [name]: value }));
    }
  };

  const validate = () => {
    const newErrors: { [key: string]: string } = {};
    if (!form.name) newErrors.name = "Name is required";
    if (!form.contact) newErrors.contact = "Contact is required";
    if (!form.address) newErrors.address = "Address is required";
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
    const formData = new FormData();
    formData.append("name", form.name);
    formData.append("type", form.type);
    formData.append("contact", form.contact);
    formData.append("address", form.address);
    if (form.image) formData.append("image", form.image);

    try {
      if (isEdit && id) {
        await api.update(`/api/supplier/${id}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      } else {
        await api.create("/api/supplier/create", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      }
      navigate("/admin/product/suppliers");
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
        title={isEdit ? "Edit Supplier" : "Add Supplier"}
        name={isEdit ? "Edit Supplier" : "Add Supplier"}
        breadCrumbItems={["Fitmate", "Suppliers", isEdit ? "Edit Supplier" : "Add Supplier"]}
      />
      <div className="col-span-12 mx-auto">
        <form
          className="card p-8 col-span-12 space-y-6"
          onSubmit={handleSubmit}
          encType="multipart/form-data"
        >
          {errors.submit && <div className="text-red-500">{errors.submit}</div>}
          <div>
            <label className="block font-medium mb-1">Name</label>
            <input
              type="text"
              name="name"
              className="form-input w-full"
              value={form.name}
              onChange={handleChange}
            />
            {errors.name && <div className="text-red-500">{errors.name}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Type</label>
            <input
              type="text"
              name="type"
              className="form-input w-full"
              value={form.type}
              onChange={handleChange}
            />
          </div>
          <div>
            <label className="block font-medium mb-1">Contact</label>
            <input
              type="text"
              name="contact"
              className="form-input w-full"
              value={form.contact}
              onChange={handleChange}
            />
            {errors.contact && <div className="text-red-500">{errors.contact}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Address</label>
            <input
              type="text"
              name="address"
              className="form-input w-full"
              value={form.address}
              onChange={handleChange}
            />
            {errors.address && <div className="text-red-500">{errors.address}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Image</label>
            <input
              type="file"
              name="image"
              accept="image/*"
              className="form-input w-full"
              ref={fileInputRef}
              onChange={handleChange}
            />
            {preview && (
              <img
                src={preview}
                alt="Preview"
                className="mt-2 rounded w-32 h-32 object-cover"
              />
            )}
          </div>
          <div className="flex justify-end gap-2">
            <button
              type="button"
              className="btn bg-gray-200 text-gray-700"
              onClick={() => navigate("/admin/product/suppliers")}
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

export default AddEditSupplier;