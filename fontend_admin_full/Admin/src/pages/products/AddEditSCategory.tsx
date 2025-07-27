import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type SCategoryForm = {
  name: string;
  description: string;
};

const AddEditSCategory = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<SCategoryForm>({
    name: "",
    description: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isEdit) {
      fetchSCategory();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchSCategory = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/scategory/${id}`);
      setForm({
        name: res.data.data.name || "",
        description: res.data.data.description || "",
      });
    } catch (err) {
      setError("Failed to load category");
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      if (isEdit) {
        await api.update(`/api/scategory/${id}`, form);
      } else {
        await api.create("/api/scategory/create", form);
      }
      navigate("/admin/product/scategory");
    } catch (err) {
      setError("Failed to save category");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit SCategory" : "Add SCategory"}
        title={isEdit ? "Edit SCategory" : "Add SCategory"}
        breadCrumbItems={["Fitmate", "SCategory", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} SCategory</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4">
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
              {error && <div className="text-red-600">{error}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/product/scategory")}
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

export default AddEditSCategory;