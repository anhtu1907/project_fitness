import React, { useEffect, useState, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type ExerciseCategoryForm = {
  categoryName: string;
  categoryImage: File | null;
};

const AddEditExerciseCategory = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<ExerciseCategoryForm>({
    categoryName: "",
    categoryImage: null,
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    if (isEdit) {
      fetchCategory();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchCategory = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/exercise-categories/${id}`);
      const data = res.data.data;
      setForm({
        categoryName: data.categoryName || "",
        categoryImage: null,
      });
      if (data.categoryImage) {
        setPreview(`${BASE_URL}/resources/${data.categoryImage}`);
      }
    } catch (err) {
      setErrors({ submit: "Failed to load category" });
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type, files } = e.target as any;
    if (type === "file") {
      setForm((prev) => ({
        ...prev,
        categoryImage: files && files[0] ? files[0] : null,
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
    formData.append("categoryName", form.categoryName);
    if (form.categoryImage) formData.append("categoryImage", form.categoryImage);

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(`/api/admin/exercise-categories/${id}`, formData);
      } else {
        res = await api.create("/api/admin/exercise-categories/create", formData);
      }
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        navigate("/admin/exercise/exercise-categories");
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
        name={isEdit ? "Edit Exercise Category" : "Add Exercise Category"}
        title={isEdit ? "Edit Exercise Category" : "Add Exercise Category"}
        breadCrumbItems={["Fitmate", "Exercise Categories", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Exercise Category</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4" encType="multipart/form-data">
              <div>
                <label className="block mb-1 font-medium">Category Name</label>
                <input
                  type="text"
                  name="categoryName"
                  value={form.categoryName}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.categoryName && <div className="text-red-500">{errors.categoryName}</div>}
              </div>
              <div>
                <label className="block mb-1 font-medium">Category Image</label>
                <input
                  type="file"
                  name="categoryImage"
                  accept="image/*"
                  className="form-input w-full"
                  ref={fileInputRef}
                  onChange={handleChange}
                  disabled={loading}
                />
                {preview && (
                  <img src={preview} alt="Preview" className="mt-2 rounded w-32 h-32 object-cover" />
                )}
                {errors.categoryImage && <div className="text-red-500">{errors.categoryImage}</div>}
              </div>
              {errors.submit && <div className="text-red-500">{errors.submit}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/exercise/exercise-categories")}
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

export default AddEditExerciseCategory;