import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import { useDropzone } from "react-dropzone";

const BASE_URL = config.API_URL;
const api = new APICore();

type MealSubCategoryForm = {
  subCategoryName: string;
  subCategoryImage: File | null;
  description: string;
  categoryId: number | "";
};

type MealCategory = {
  id: number;
  categoryName: string;
};

const AddEditMealSubCategory = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<MealSubCategoryForm>({
    subCategoryName: "",
    subCategoryImage: null,
    description: "",
    categoryId: "",
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [categories, setCategories] = useState<MealCategory[]>([]);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    api
      .get("/api/admin/meal-category")
      .then((res: any) => setCategories(res.data.data || []));
    if (isEdit) {
      fetchSubCategory();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchSubCategory = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/meal-subcategory/${id}`);
      const data = res.data.data;
      setForm({
        subCategoryName: data.subCategoryName || "",
        subCategoryImage: null,
        description: data.description || "",
        categoryId: data.categoryId || "",
      });
      if (data.subCategoryImage) {
        if (/^https?:\/\//i.test(data.subCategoryImage)) {
          setPreview(data.subCategoryImage);
        } else {
          setPreview(`${BASE_URL}/resources/${data.subCategoryImage}`);
        }
      }
    } catch (err) {
      setErrors({ submit: "Failed to load subcategory" });
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) => {
    const { name, value } = e.target;
    if (name === "categoryId") {
      setForm((prev) => ({
        ...prev,
        categoryId: Number(value),
      }));
    } else {
      setForm((prev) => ({
        ...prev,
        [name]: value,
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});

    if (
      !form.subCategoryName ||
      !form.subCategoryImage ||
      !form.description ||
      !form.categoryId
    ) {
      setErrors({
        subCategoryName: !form.subCategoryName
          ? "Subcategory name is required"
          : "",
        subCategoryImage: !form.subCategoryImage
          ? "Subcategory image is required"
          : "",
        description: !form.description ? "Description is required" : "",
        categoryId: !form.categoryId ? "Category is required" : "",
      });
      setLoading(false);
      return;
    }

    const formData = new FormData();
    formData.append("subCategoryName", form.subCategoryName);
    formData.append("subCategoryImage", form.subCategoryImage);
    formData.append("description", form.description);
    formData.append("categoryId", form.categoryId.toString());

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(`/api/admin/meal-subcategory/${id}`, formData);
      } else {
        res = await api.create("/api/admin/meal-subcategory/create", formData);
      }
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        navigate("/admin/meal/meal-subcategory");
      } else {
        setErrors({ submit: res?.data?.message || "Save failed" });
      }
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

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: {
      "image/*": [],
    },
    multiple: false,
    onDrop: (acceptedFiles: File[]) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        const file = acceptedFiles[0];
        setForm((prev) => ({
          ...prev,
          subCategoryImage: file,
        }));
        setPreview(URL.createObjectURL(file));
      }
    },
  });

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Meal Subcategory" : "Add Meal Subcategory"}
        title={isEdit ? "Edit Meal Subcategory" : "Add Meal Subcategory"}
        breadCrumbItems={["Fitmate", "MealSubCategorys", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">
              {isEdit ? "Edit" : "Add"} Meal Subcategory
            </h4>
          </div>
          <div className="p-6">
            <form
              onSubmit={handleSubmit}
              className="flex flex-col gap-4"
              encType="multipart/form-data"
            >
              <div>
                <label className="block mb-1 font-medium">Subcategory Name</label>
                <input
                  type="text"
                  name="subCategoryName"
                  value={form.subCategoryName}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.subCategoryName && (
                  <div className="text-red-500">{errors.subCategoryName}</div>
                )}
              </div>

              <div>
                <label className="block mb-1 font-medium">Subcategory Image</label>
                <div
                  {...getRootProps()}
                  className="border border-dashed border-gray-400 p-4 rounded cursor-pointer hover:bg-gray-100 text-center"
                >
                  <input {...getInputProps()} />
                  {isDragActive ? (
                    <p>Drop the image here...</p>
                  ) : (
                    <p>Drag & drop an image here, or click to select one</p>
                  )}
                  {preview && (
                    <img
                      src={preview}
                      alt="Preview"
                      className="mt-2 rounded w-32 h-32 object-cover mx-auto"
                    />
                  )}
                </div>
                {preview && (
                  <button
                    type="button"
                    onClick={() => {
                      setForm((prev) => ({ ...prev, subCategoryImage: null }));
                      setPreview(null);
                    }}
                    className="text-sm text-red-500 mt-1"
                  >
                    Remove Image
                  </button>
                )}
                {errors.subCategoryImage && (
                  <div className="text-red-500">{errors.subCategoryImage}</div>
                )}
              </div>

              <div>
                <label className="block mb-1 font-medium">Description</label>
                <textarea
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  className="form-input w-full"
                  rows={3}
                  required
                  disabled={loading}
                />
                {errors.description && (
                  <div className="text-red-500">{errors.description}</div>
                )}
              </div>

              <div>
                <label className="block mb-1 font-medium">Category</label>
                <select
                  name="categoryId"
                  value={form.categoryId}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                >
                  <option value="">Select category</option>
                  {categories.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.categoryName}
                    </option>
                  ))}
                </select>
                {errors.categoryId && (
                  <div className="text-red-500">{errors.categoryId}</div>
                )}
              </div>

              {errors.submit && (
                <div className="text-red-500">{errors.submit}</div>
              )}

              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/meal/meal-subcategory")}
                  disabled={loading}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn bg-primary text-white"
                  disabled={loading}
                >
                  {isEdit ? "Update" : "Create"}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default AddEditMealSubCategory;
