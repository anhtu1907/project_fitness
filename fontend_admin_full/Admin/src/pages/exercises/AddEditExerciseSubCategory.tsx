import React, { useEffect, useState, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type ExerciseSubCategoryForm = {
  subCategoryName: string;
  subCategoryImage: File | null;
  description: string;
};

const AddEditExerciseSubCategory = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<ExerciseSubCategoryForm>({
    subCategoryName: "",
    subCategoryImage: null,
    description: "",
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    if (isEdit) {
      fetchSubCategory();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchSubCategory = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/exercise-sub-category/${id}`);
      const data = res.data.data;
      setForm({
        subCategoryName: data.subCategoryName || "",
        subCategoryImage: null,
        description: data.description || "",
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
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value, type, files } = e.target as any;
    if (type === "file") {
      setForm((prev) => ({
        ...prev,
        subCategoryImage: files && files[0] ? files[0] : null,
      }));
      if (files && files[0]) {
        setPreview(URL.createObjectURL(files[0]));
      }
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
    const formData = new FormData();
    formData.append("subCategoryName", form.subCategoryName);
    if (form.subCategoryImage)
      formData.append("subCategoryImage", form.subCategoryImage);
    formData.append("description", form.description);

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(
          `/api/admin/exercise-sub-category/${id}`,
          formData
        );
      } else {
        res = await api.create(
          "/api/admin/exercise-sub-category/create",
          formData
        );
      }
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        navigate("/admin/exercise/exercise-sub-categories");
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

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Exercise Subcategory" : "Add Exercise Subcategory"}
        title={
          isEdit ? "Edit Exercise Subcategory" : "Add Exercise Subcategory"
        }
        breadCrumbItems={[
          "Fitmate",
          "Exercise Subcategories",
          isEdit ? "Edit" : "Add",
        ]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">
              {isEdit ? "Edit" : "Add"} Exercise Subcategory
            </h4>
          </div>
          <div className="p-6">
            <form
              onSubmit={handleSubmit}
              className="flex flex-col gap-4"
              encType="multipart/form-data"
            >
              <div>
                <label className="block mb-1 font-medium">
                  Subcategory Name
                </label>
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
                <label className="block mb-1 font-medium">
                  Subcategory Image
                </label>
                <input
                  type="file"
                  name="subCategoryImage"
                  accept="image/*"
                  className="form-input w-full"
                  ref={fileInputRef}
                  onChange={handleChange}
                  disabled={loading}
                />
                {preview && (
                  <img
                    src={preview}
                    alt="Preview"
                    className="mt-2 rounded w-32 h-32 object-cover"
                  />
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
              {errors.submit && (
                <div className="text-red-500">{errors.submit}</div>
              )}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() =>
                    navigate("/admin/exercise/exercise-sub-categories")
                  }
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

export default AddEditExerciseSubCategory;
