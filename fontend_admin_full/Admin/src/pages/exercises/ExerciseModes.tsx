import React, { useEffect, useState } from "react";
import { PageBreadcrumb } from "../../components";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type ExerciseMode = {
  id: number;
  modeName: string;
};

const ExerciseModes = () => {
  const [modes, setModes] = useState<ExerciseMode[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchModes();
  }, []);

  const fetchModes = async () => {
    try {
      const res = await api.get("/api/admin/exercise-mode");
      setModes(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name="Exercise Modes"
        title="Exercise Modes"
        breadCrumbItems={["Fitmate", "Exercise Modes", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Exercise Mode List</h4>
            <Link
              to="/admin/exercise/exercise-mode/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Mode
            </Link>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <table className="min-w-full table-auto border">
                <thead>
                  <tr>
                    <th className="px-2 py-2 border">ID</th>
                    <th className="px-2 py-2 border">Mode Name</th>
                    <th className="px-2 py-2 border">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {modes.map((m) => (
                    <tr key={m.id}>
                      <td className="px-2 py-2 border">{m.id}</td>
                      <td className="px-2 py-2 border">{m.modeName}</td>
                      <td className="px-2 py-2 border">
                        <Link
                          to={`/admin/exercise/exercise-mode/edit/${m.id}`}
                          className="me-2 text-blue-600"
                          title="Edit"
                        >
                          <i className="mgc_edit_line text-lg"></i>
                        </Link>
                        <a
                          href={`/admin/exercise/exercise-mode/delete/${m.id}`}
                          className="ms-2 text-red-600 disabled"
                          title="Delete"
                          tabIndex={-1}
                          aria-disabled="true"
                          onClick={(e) => e.preventDefault()}
                        >
                          <i className="mgc_delete_line text-lg"></i>
                        </a>
                      </td>
                    </tr>
                  ))}
                  {modes.length === 0 && (
                    <tr>
                      <td colSpan={3} className="text-center py-4">
                        No exercise modes found.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default ExerciseModes;