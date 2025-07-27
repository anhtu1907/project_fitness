import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type ExerciseModeForm = {
  modeName: string;
};

const AddEditExerciseMode = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<ExerciseModeForm>({ modeName: "" });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isEdit) {
      fetchMode();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchMode = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/exercise-mode/id/${id}`);
      setForm({ modeName: res.data.data.modeName || "" });
    } catch (err) {
      setError("Failed to load exercise mode");
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
        await api.update(`/api/admin/exercise-mode/${id}`, form);
      } else {
        await api.create("/api/admin/exercise-mode/create", form);
      }
      navigate("/admin/exercise/exercise-modes");
    } catch (err) {
      setError("Failed to save exercise mode");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Exercise Mode" : "Add Exercise Mode"}
        title={isEdit ? "Edit Exercise Mode" : "Add Exercise Mode"}
        breadCrumbItems={["Fitmate", "Exercise Modes", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Exercise Mode</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4">
              <div>
                <label className="block mb-1 font-medium">Mode Name</label>
                <input
                  type="text"
                  name="modeName"
                  value={form.modeName}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
              </div>
              {error && <div className="text-red-600">{error}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/exercise/exercise-modes")}
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

export default AddEditExerciseMode;