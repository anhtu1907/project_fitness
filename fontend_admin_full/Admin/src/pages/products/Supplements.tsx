import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type Supplement = {
  id: number;
  size: number;
  ingredient: string;
  product?: {
    id: number;
    name: string;
    price: number;
    image?: { storedName: string; relativePath: string };
    supplier?: { name: string };
  };
};

const PAGE_SIZE = 5;

const SupplementList = () => {
  const [supplements, setSupplements] = useState<Supplement[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchSupplements();
  }, []);

  const fetchSupplements = async () => {
    try {
      const res = await api.get("/api/supplement");
      setSupplements(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(supplements.length / PAGE_SIZE);
  const pagedSupplements = supplements.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="Supplements"
        title="Supplements"
        breadCrumbItems={["Fitmate", "Supplements"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Supplement List</h4>
            <Link
              to="/admin/product/supplement/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Supplement
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
                      <th className="px-2 py-2 border">Image</th>
                      <th className="px-2 py-2 border">Size</th>
                      <th className="px-2 py-2 border">Ingredient</th>
                      <th className="px-2 py-2 border">Product</th>
                      <th className="px-2 py-2 border">Supplier</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedSupplements.map((s) => (
                      <tr key={s.id}>
                        <td className="px-2 py-2 border">{s.id}</td>
                        <td className="px-2 py-2 border">
                          {s.product?.image?.storedName ? (
                            <img
                              src={
                                BASE_URL +
                                "/resources/" +
                                s.product.image.storedName
                              }
                              alt={s.product.name}
                              style={{
                                width: 60,
                                height: 60,
                                objectFit: "cover",
                                borderRadius: 8,
                              }}
                            />
                          ) : (
                            ""
                          )}
                        </td>
                        <td className="px-2 py-2 border">{s.size}</td>
                        <td className="px-2 py-2 border">{s.ingredient}</td>
                        <td className="px-2 py-2 border">
                          {s.product ? s.product.name : ""}
                        </td>
                        <td className="px-2 py-2 border">
                          {s.product?.supplier?.name || ""}
                        </td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/product/supplement/edit/${s.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/product/supplement/delete/${s.id}`}
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
                    {pagedSupplements.length === 0 && (
                      <tr>
                        <td colSpan={7} className="text-center py-4">
                          No supplements found.
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

export default SupplementList;