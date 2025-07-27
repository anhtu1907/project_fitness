import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import Select from "react-select";
import { toast } from "react-hot-toast";
import { useDropzone } from "react-dropzone";

const BASE_URL = config.API_URL;
const api = new APICore();

const initialState = {
  name: "",
  description: "",
  price: "",
  stock: "",
  rating: "5",
  image: null as File | null,
  supplierId: "",
  promotions: "",
  equipmentId: "",
  supplementId: "",
};

const AddEditProduct = () => {
  const [form, setForm] = useState(initialState);
  const [preview, setPreview] = useState<string | null>(null);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [loading, setLoading] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [suppliers, setSuppliers] = useState<any[]>([]);
  const [promotions, setPromotions] = useState<any[]>([]);
  const [equipments, setEquipments] = useState<any[]>([]);
  const [supplements, setSupplements] = useState<any[]>([]);
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();

  useEffect(() => {
    api.get("/api/supplier").then((res: any) => setSuppliers(res.data.data || []));
    api.get("/api/promotion").then((res: any) => setPromotions(res.data.data || []));
    api.get("/api/equipment").then((res: any) => setEquipments(res.data.data || []));
    api.get("/api/supplement").then((res: any) => setSupplements(res.data.data || []));
  }, []);

  useEffect(() => {
    if (id) {
      setIsEdit(true);
      api.get(`/api/product/id/${id}`).then(async (res: any) => {
        const data = res.data.data;
        setForm({
          name: data.name || "",
          description: data.description || "",
          price: data.price?.toString() || "",
          stock: data.stock?.toString() || "",
          rating: data.rating?.toString() || "5",
          image: null,
          supplierId: data.supplier?.toString() || "",
          promotions: data.promotions?.[0]?.promotionId?.toString() || "",
          equipmentId: data.equipment?.toString() || "",
          supplementId: data.supplement?.toString() || "",
        });
        if (data.image) {
          setPreview(`${BASE_URL}/resources/${data.image}`);
        }
      });
    }
  }, [id]);

  const validate = () => {
    const newErrors: { [key: string]: string } = {};
    if (!form.name) newErrors.name = "Product name is required";
    if (!form.price) newErrors.price = "Price is required";
    else if (Number(form.price) <= 0) newErrors.price = "Price must be greater than 0";
    if (!form.stock) newErrors.stock = "Stock is required";
    else if (Number(form.stock) < 0) newErrors.stock = "Stock cannot be negative";
    if (form.rating && Number(form.rating) < 0) newErrors.rating = "Rating must be zero or more";
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
    formData.append("description", form.description);
    formData.append("price", form.price);
    formData.append("stock", form.stock);
    formData.append("rating", form.rating || "5");
    if (form.image) formData.append("image", form.image);
    if (form.supplierId) formData.append("supplierId", form.supplierId);
    if (form.promotions) formData.append("promotionId", form.promotions);
    if (form.equipmentId) formData.append("equipmentId", form.equipmentId);
    if (form.supplementId) formData.append("supplementId", form.supplementId);

    try {
      if (isEdit && id) {
        await api.update(`/api/product/${id}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        toast.success("Product updated successfully!");
      } else {
        await api.create("/api/product/create", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        toast.success("Product created successfully!");
      }
      navigate("/admin/product/products");
    } catch (err: any) {
      if (err?.response?.data?.errors) {
        setErrors(err.response.data.errors);
      } else {
        setErrors({ submit: err?.response?.data?.message || "Save failed" });
      }
      toast.error("Failed to save product!");
    } finally {
      setLoading(false);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: { 'image/*': [] },
    multiple: false,
    onDrop: (acceptedFiles: File[]) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        const file = acceptedFiles[0];
        setForm((prev) => ({ ...prev, image: file }));
        setPreview(URL.createObjectURL(file));
      }
    },
  });

  const supplierOptions = suppliers.map((s) => ({ value: s.id, label: s.name }));
  const promotionOptions = promotions.map((p) => ({
    value: p.promotionId || p.id,
    label: p.promotionName || p.name,
  }));
  const equipmentOptions = equipments.map((e) => ({ value: e.id, label: e.name }));
  const supplementOptions = supplements.map((s) => ({ value: s.id, label: s.name }));

  return (
    <>
      <PageBreadcrumb
        title={isEdit ? "Edit Product" : "Add Product"}
        name={isEdit ? "Edit Product" : "Add Product"}
        breadCrumbItems={["Fitmate", "Products", isEdit ? "Edit Product" : "Add Product"]}
      />
      <div className="col-span-12 mx-auto">
        <form className="card p-8 space-y-6" onSubmit={handleSubmit} encType="multipart/form-data">
          <h2 className="text-xl font-semibold mb-4">
            {isEdit ? "Edit Product" : "Add New Product"}
          </h2>
          {errors.submit && <div className="text-red-500">{errors.submit}</div>}
          <div>
            <label className="block font-medium mb-1">Product Name<span className="text-red-500">*</span></label>
            <input
              type="text"
              className="form-input w-full"
              value={form.name}
              onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))}
            />
            {errors.name && <div className="text-red-500">{errors.name}</div>}
          </div>
          <div>
            <label className="block font-medium mb-1">Description</label>
            <textarea
              className="form-input w-full"
              value={form.description}
              onChange={(e) => setForm((prev) => ({ ...prev, description: e.target.value }))}
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block font-medium mb-1">Price<span className="text-red-500">*</span></label>
              <input
                type="number"
                className="form-input w-full"
                value={form.price}
                onChange={(e) => setForm((prev) => ({ ...prev, price: e.target.value }))}
                min={0}
                step="0.01"
              />
              {errors.price && <div className="text-red-500">{errors.price}</div>}
            </div>
            <div>
              <label className="block font-medium mb-1">Stock<span className="text-red-500">*</span></label>
              <input
                type="number"
                className="form-input w-full"
                value={form.stock}
                onChange={(e) => setForm((prev) => ({ ...prev, stock: e.target.value }))}
                min={0}
              />
              {errors.stock && <div className="text-red-500">{errors.stock}</div>}
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">Image</label>
            <div {...getRootProps()} className="border border-dashed border-gray-400 p-4 rounded cursor-pointer hover:bg-gray-100">
              <input {...getInputProps()} />
              {isDragActive ? <p>Drop the image here ...</p> : <p>Drag 'n' drop or click to upload</p>}
              {preview && <img src={preview} alt="Preview" className="mt-2 rounded w-32 h-32 object-cover" />}
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">Supplier</label>
            <Select
              options={supplierOptions}
              value={supplierOptions.find(opt => opt.value === Number(form.supplierId))}
              onChange={(opt) => setForm((prev) => ({ ...prev, supplierId: opt?.value.toString() || "" }))}
              isClearable
            />
          </div>
          <div>
            <label className="block font-medium mb-1">Promotion</label>
            <Select
              options={promotionOptions}
              value={promotionOptions.find(opt => opt.value === Number(form.promotions))}
              onChange={(opt) => setForm((prev) => ({ ...prev, promotions: opt?.value.toString() || "" }))}
              isClearable
            />
            {(() => {
              const promo = promotions.find(p => String(p.promotionId || p.id) === String(form.promotions));
              if (!promo) return <div className="text-gray-400">No promotion selected</div>;
              const price = Number(form.price) || 0;
              const discount = Number(promo.discountOverride || promo.discount || 0);
              const finalPrice = price * (1 - discount);
              const formatDate = (timestamp: number) => new Date(timestamp * 1000).toLocaleString("vi-VN");
              return (
                <div className="mt-2 p-3 border rounded bg-gray-50 text-sm">
                  <div><strong>Promotion:</strong> {promo.promotionName || promo.name}</div>
                  <div>Discount: {discount * 100}%</div>
                  <div>Start: {formatDate(promo.startDate)}</div>
                  <div>End: {formatDate(promo.endDate)}</div>
                  <div className="mt-1 text-green-600 font-medium">Final Price: {finalPrice.toLocaleString()} $</div>
                </div>
              );
            })()}
          </div>
          <div className="flex justify-end gap-2">
            <button type="button" className="btn bg-gray-200" onClick={() => navigate("/admin/product/products")}>Cancel</button>
            <button type="submit" className="btn bg-primary text-white" disabled={loading}>
              {loading ? (isEdit ? "Saving..." : "Saving...") : (isEdit ? "Update" : "Save")}
            </button>
          </div>
        </form>
      </div>
    </>
  );
};

export default AddEditProduct;
