import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type ProgramForm = {
  programName: string;
};

const AddEditProgram = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();

  const [form, setForm] = useState<ProgramForm>({ programName: "" });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isEdit) {
      fetchProgram();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchProgram = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/exercise-program/id/${id}`);
      setForm({ programName: res.data.data.programName || "" });
    } catch (err) {
      setError("Failed to load exercise program");
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
        await api.update(`/api/admin/exercise-program/${id}`, form);
      } else {
        await api.create("/api/admin/exercise-program/create", form);
      }
      navigate("/admin/exercise/exercise-programs");
    } catch (err) {
      setError("Failed to save exercise program");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Exercise Program" : "Add Exercise Program"}
        title={isEdit ? "Edit Exercise Program" : "Add Exercise Program"}
        breadCrumbItems={["Fitmate", "Exercise Programs", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Exercise Program</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4">
              <div>
                <label className="block mb-1 font-medium">Program Name</label>
                <input
                  type="text"
                  name="programName"
                  value={form.programName}
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
                  onClick={() => navigate("/admin/exercise/exercise-programs")}
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

export default AddEditProgram;