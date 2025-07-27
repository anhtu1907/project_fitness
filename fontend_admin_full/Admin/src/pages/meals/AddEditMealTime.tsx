import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type MealTimeForm = {
  timeName: string;
};

const AddEditMealTime = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<MealTimeForm>({ timeName: "" });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isEdit) {
      fetchMealTime();
    }

  }, [id]);

  const fetchMealTime = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/meal-times/${id}`);
      setForm({ timeName: res.data.data.name || "" });
    } catch (err) {
      setError("Failed to load meal time");
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      if (isEdit) {
        await api.update(`/api/admin/meal-times/${id}`, form);
      } else {
        await api.create("/api/admin/meal-times/create", form);
      }
      navigate("/admin/meal/meal-times");
    } catch (err) {
      setError("Failed to save meal time");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Meal Time" : "Add Meal Time"}
        title={isEdit ? "Edit Meal Time" : "Add Meal Time"}
        breadCrumbItems={["Fitmate", "MealTimes", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Meal Time</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4">
              <div>
                <label className="block mb-1 font-medium">Time Name</label>
                <input
                  type="text"
                  name="timeName"
                  value={form.timeName}
                  onChange={handleChange}
                  className="form-input w-full"
                  disabled={loading}
                />
              </div>
              {error && <div className="text-red-600">{error}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/meal/meal-times")}
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

export default AddEditMealTime;