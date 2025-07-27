import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();
const PAGE_SIZE = 5;

type MealSubCategory = {
  id: number;
  subCategoryName: string;
  subCategoryImage?: string;
  description: string;
  categoryId: number;
};

type MealCategory = {
  id: number;
  categoryName: string;
};

const MealSubCategorys = () => {
  const [subCategories, setSubCategories] = useState<MealSubCategory[]>([]);
  const [categories, setCategories] = useState<MealCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchSubCategories();
    api.get("/api/admin/meal-category").then((res: any) => setCategories(res.data.data || []));
  }, []);

  const fetchSubCategories = async () => {
    try {
      const res = await api.get("/api/admin/meal-subcategory");
      setSubCategories(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  const getCategoryName = (id: number) =>
    categories.find((c) => c.id === id)?.categoryName || "";

  const totalPages = Math.ceil(subCategories.length / PAGE_SIZE);
  const pagedSubCategories = subCategories.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="MealSubCategorys"
        title="Meal Subcategories"
        breadCrumbItems={["Fitmate", "MealSubCategorys"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Meal Subcategory List</h4>
            <Link
              to="/admin/meal/meal-subcategory/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Meal Subcategory
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
                      <th className="px-2 py-2 border">Description</th>
                      <th className="px-2 py-2 border">Category</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedSubCategories.map((s) => (
                      <tr key={s.id}>
                        <td className="px-2 py-2 border">{s.id}</td>
                        <td className="px-2 py-2 border">
                          {s.subCategoryImage ? (
                            (() => {
                              const imageUrl = s.subCategoryImage.startsWith("http")
                                ? s.subCategoryImage
                                : BASE_URL + "/resources/" + s.subCategoryImage;

                              const isImage = /\.(jpg|jpeg|png|webp|gif)$/i.test(imageUrl);

                              return isImage ? (
                                <img
                                  src={imageUrl}
                                  alt={s.subCategoryName}
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
                        <td className="px-2 py-2 border">{s.subCategoryName}</td>
                        <td className="px-2 py-2 border">{s.description}</td>
                        <td className="px-2 py-2 border">{getCategoryName(s.categoryId)}</td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/meal/meal-subcategory/edit/${s.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/meal/meal-subcategory/delete/${s.id}`}
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
                    {pagedSubCategories.length === 0 && (
                      <tr>
                        <td colSpan={6} className="text-center py-4">
                          No meal subcategories found.
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

export default MealSubCategorys;