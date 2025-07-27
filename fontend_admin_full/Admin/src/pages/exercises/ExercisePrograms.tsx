import React, { useEffect, useState } from "react";
import { PageBreadcrumb } from "../../components";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

type ExerciseProgram = {
  id: number;
  programName: string;
};

const ExercisePrograms = () => {
  const [programs, setPrograms] = useState<ExerciseProgram[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchPrograms();
  }, []);

  const fetchPrograms = async () => {
    try {
      const res = await api.get("/api/admin/exercise-program");
      setPrograms(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name="Exercise Programs"
        title="Exercise Programs"
        breadCrumbItems={["Fitmate", "Exercise Programs", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Exercise Program List</h4>
            <Link
              to="/admin/exercise/exercise-program/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Program
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
                    <th className="px-2 py-2 border">Program Name</th>
                    <th className="px-2 py-2 border">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {programs.map((p) => (
                    <tr key={p.id}>
                      <td className="px-2 py-2 border">{p.id}</td>
                      <td className="px-2 py-2 border">{p.programName}</td>
                      <td className="px-2 py-2 border">
                        <Link
                          to={`/admin/exercise/exercise-program/edit/${p.id}`}
                          className="me-2 text-blue-600"
                          title="Edit"
                        >
                          <i className="mgc_edit_line text-lg"></i>
                        </Link>
                        <a
                          href={`/admin/exercise/exercise-program/delete/${p.id}`}
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
                  {programs.length === 0 && (
                    <tr>
                      <td colSpan={3} className="text-center py-4">
                        No exercise programs found.
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

export default ExercisePrograms;