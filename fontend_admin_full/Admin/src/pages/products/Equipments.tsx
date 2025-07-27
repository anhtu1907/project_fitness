import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type Product = {
  id: number;
  name: string;
  image?: string;
  supplier?: { name: string };
};

type Equipment = {
  id: number;
  size: number;
  color: string;
  gender: string;
  productId: number;
  product?: Product;
};

const PAGE_SIZE = 5;

const Equipments = () => {
  const [equipments, setEquipments] = useState<Equipment[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchEquipments();
  }, []);

  const fetchEquipments = async () => {
    try {
      const res = await api.get("/api/equipment");
      const equipmentsRaw: Equipment[] = res.data.data || [];
      
      // Nếu product chưa được gắn sẵn, ta fetch theo productId
      const enrichedEquipments = await Promise.all(
        equipmentsRaw.map(async (eq) => {
          if (eq.productId) {
            try {
              const productRes = await api.get(`/api/product/id/${eq.productId}`);
              console.log(`Fetched product for equipment ${eq.id}:`, productRes.data.data);
              return { ...eq, product: productRes.data.data };
            } catch (err) {
              console.warn(`Failed to fetch product for equipment ${eq.id}`);
              return eq;
            }
          }
          return eq;
        })
      );

      setEquipments(enrichedEquipments);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(equipments.length / PAGE_SIZE);
  const pagedEquipments = equipments.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="Equipments"
        title="Equipments"
        breadCrumbItems={["Fitmate", "Equipments"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Equipment List</h4>
            <Link
              to="/admin/product/equipment/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Equipment
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
                      <th className="px-2 py-2 border">Color</th>
                      <th className="px-2 py-2 border">Gender</th>
                      <th className="px-2 py-2 border">Product</th>
                      
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedEquipments.map((e) => (
                      <tr key={e.id}>
                        <td className="px-2 py-2 border">{e.id}</td>
                        <td className="px-2 py-2 border">
                          {e.product?.image ? (
                            <img
                              src={`${BASE_URL}/resources/${e.product.image}`}
                              alt={e.product.name}
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
                        <td className="px-2 py-2 border">{e.size}</td>
                        <td className="px-2 py-2 border">{e.color}</td>
                        <td className="px-2 py-2 border">{e.gender}</td>
                        <td className="px-2 py-2 border">{e.product?.name || ""}</td>
                        
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/product/equipment/edit/${e.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/product/equipment/delete/${e.id}`}
                            className="ms-2 text-red-600 disabled"
                            title="Delete"
                            tabIndex={-1}
                            aria-disabled="true"
                            onClick={(ev) => ev.preventDefault()}
                          >
                            <i className="mgc_delete_line text-lg"></i>
                          </a>
                        </td>
                      </tr>
                    ))}
                    {pagedEquipments.length === 0 && (
                      <tr>
                        <td colSpan={8} className="text-center py-4">
                          No equipments found.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
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

export default Equipments;
