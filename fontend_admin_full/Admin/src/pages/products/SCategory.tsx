import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const api = new APICore();
const PAGE_SIZE = 5;

type SCategory = {
  id: number;
  name: string;
  description: string;
};

const SCategoryList = () => {
  const [scategories, setSCategories] = useState<SCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchSCategories();
  }, []);

  const fetchSCategories = async () => {
    try {
      const res = await api.get("/api/scategory");
      setSCategories(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(scategories.length / PAGE_SIZE);
  const pagedSCategories = scategories.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="SCategory"
        title="Supplement Categories"
        breadCrumbItems={["Fitmate", "SCategory"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">SCategory List</h4>
            <Link
              to="/admin/product/scategory/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New SCategory
            </Link>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <>
                <table className="min-w-full table-auto border">
                  <thead>
                    <tr>
                      <th className="px-2 py-2 border">ID</th>
                      <th className="px-2 py-2 border">Name</th>
                      <th className="px-2 py-2 border">Description</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedSCategories.map((c) => (
                      <tr key={c.id}>
                        <td className="px-2 py-2 border">{c.id}</td>
                        <td className="px-2 py-2 border">{c.name}</td>
                        <td className="px-2 py-2 border">{c.description}</td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/product/scategory/edit/${c.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          {/* <a
                            href={`/admin/product/scategory/delete/${c.id}`}
                            className="ms-2 text-red-600 disabled"
                            title="Delete"
                            tabIndex={-1}
                            aria-disabled="true"
                            onClick={(e) => e.preventDefault()}
                          >
                            <i className="mgc_delete_line text-lg"></i>
                          </a> */}
                        </td>
                      </tr>
                    ))}
                    {pagedSCategories.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center py-4">
                          No categories found.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
                {/* Pagination controls */}
                <div className="flex justify-end items-center gap-2 mt-4">
                  <button
                    className="btn btn-sm bg-gray-200"
                    onClick={handlePrev}
                    disabled={page === 1}
                  >
                    Prev
                  </button>
                  <span>
                    Page {page} of {totalPages}
                  </span>
                  <button
                    className="btn btn-sm bg-gray-200"
                    onClick={handleNext}
                    disabled={page === totalPages || totalPages === 0}
                  >
                    Next
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default SCategoryList;