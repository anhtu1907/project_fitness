import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();
const PAGE_SIZE = 5;

type MealCategory = {
  id: number;
  categoryImage?: string;
  categoryName: string;
  subCategoryIds: number[];
};

const MealCategorys = () => {
  const [categories, setCategories] = useState<MealCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const res = await api.get("/api/admin/meal-category");
      setCategories(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(categories.length / PAGE_SIZE);
  const pagedCategories = categories.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="MealCategorys"
        title="Meal Categories"
        breadCrumbItems={["Fitmate", "MealCategories"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Meal Category List</h4>
            <Link
              to="/admin/meal/meal-category/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Meal Category
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
                      <th className="px-2 py-2 border">Name</th>
                      <th className="px-2 py-2 border">Subcategories</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedCategories.map((c) => (
                      <tr key={c.id}>
                        <td className="px-2 py-2 border">{c.id}</td>
                        <td className="px-2 py-2 border">
                          {c.categoryImage ? (
                            (() => {
                              const imageUrl = c.categoryImage.startsWith("http")
                                ? c.categoryImage
                                : BASE_URL + "/resources/" + c.categoryImage;

                              const isImage = /\.(jpg|jpeg|png|webp|gif)$/i.test(imageUrl);

                              return isImage ? (
                                <img
                                  src={imageUrl}
                                  alt={c.categoryName}
                                  style={{
                                    width: 60,
                                    height: 60,
                                    objectFit: "cover",
                                    borderRadius: 8,
                                  }}
                                />
                              ) : (
                                <a
                                  href={imageUrl}
                                  target="_blank"
                                  rel="noopener noreferrer"
                                  style={{ color: "blue", textDecoration: "underline" }}
                                >
                                  {imageUrl}
                                </a>
                              );
                            })()
                          ) : (
                            ""
                          )}
                        </td>
                        <td className="px-2 py-2 border">{c.categoryName}</td>
                        <td className="px-2 py-2 border">{c.subCategoryIds?.join(", ")}</td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/meal/meal-category/edit/${c.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/meal/meal-category/delete/${c.id}`}
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
                    {pagedCategories.length === 0 && (
                      <tr>
                        <td colSpan={5} className="text-center py-4">
                          No meal categories found.
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

export default MealCategorys;