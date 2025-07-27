import React, { useEffect, useState, ChangeEvent } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type ECategoryForm = {
  name: string;
  description: string;
  image?: File | null;
};

const AddEditECategory = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<ECategoryForm>({
    name: "",
    description: "",
    image: null,
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isEdit) {
      fetchECategory();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchECategory = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/ecategory/id/${id}`);
      setForm({
        name: res.data.data.name || "",
        description: res.data.data.description || "",
        image: null,
      });
      if (res.data.data.image) {
        setPreview(BASE_URL + "/resources/" + res.data.data.image);
      }
    } catch (err) {
      setError("Failed to load category");
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value, type, files } = e.target as any;
    if (type === "file") {
      setForm((prev) => ({
        ...prev,
        image: files && files[0] ? files[0] : null,
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
    setError(null);
    try {
      const formData = new FormData();
      formData.append("name", form.name);
      formData.append("description", form.description);
      if (form.image) formData.append("image", form.image);

      if (isEdit) {
        await api.update(`/api/ecategory/${id}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      } else {
        await api.create("/api/ecategory/create", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      }
      navigate("/admin/product/ecategory");
    } catch (err) {
      setError("Failed to save category");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit ECategory" : "Add ECategory"}
        title={isEdit ? "Edit ECategory" : "Add ECategory"}
        breadCrumbItems={["Fitmate", "ECategory", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} ECategory</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4" encType="multipart/form-data">
              <div>
                <label className="block mb-1 font-medium">Name</label>
                <input
                  type="text"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
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
              </div>
              <div>
                <label className="block mb-1 font-medium">Image</label>
                <input
                  type="file"
                  name="image"
                  accept="image/*"
                  onChange={handleChange}
                  className="form-input w-full"
                  disabled={loading}
                />
                {preview && (
                  <img
                    src={preview}
                    alt="Preview"
                    className="mt-2 rounded"
                    style={{ width: 100, height: 100, objectFit: "cover" }}
                  />
                )}
              </div>
              {error && <div className="text-red-600">{error}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/product/ecategory")}
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

export default AddEditECategory;