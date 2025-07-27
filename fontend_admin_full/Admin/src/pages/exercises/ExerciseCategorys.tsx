import React, { useEffect, useState } from "react";
import { PageBreadcrumb } from "../../components";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type ExerciseCategory = {
  id: number;
  categoryName: string;
  categoryImage?: string;
  subCategoryIds?: number[];
};

const ExerciseCategorys = () => {
  const [categories, setCategories] = useState<ExerciseCategory[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const res = await api.get("/api/admin/exercise-categories");
      setCategories(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name="Exercise Categories"
        title="Exercise Categories"
        breadCrumbItems={["Fitmate", "Exercise Categories", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Exercise Category List</h4>
            <Link
              to="/admin/exercise/exercise-category/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Category
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
                    <th className="px-2 py-2 border">Image</th>
                    <th className="px-2 py-2 border">Name</th>
                    <th className="px-2 py-2 border">Subcategories</th>
                    <th className="px-2 py-2 border">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {categories.map((c) => {
                    const imageUrl = c.categoryImage?.startsWith("http")
                      ? c.categoryImage
                      : BASE_URL + "/resources/" + c.categoryImage;

                    const isImage = /\.(jpg|jpeg|png|webp|gif|svg)$/i.test(imageUrl);

                    return (
                      <tr key={c.id}>
                        <td className="px-2 py-2 border">{c.id}</td>
                        <td className="px-2 py-2 border">
                          {c.categoryImage ? (
                            isImage ? (
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
                            )
                          ) : (
                            ""
                          )}
                        </td>
                        <td className="px-2 py-2 border">{c.categoryName}</td>
                        <td className="px-2 py-2 border">
                          {c.subCategoryIds && c.subCategoryIds.length > 0
                            ? c.subCategoryIds.join(", ")
                            : ""}
                        </td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/exercise/exercise-category/edit/${c.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/exercise/exercise-categories/delete/${c.id}`}
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
                    );
                  })}
                  {categories.length === 0 && (
                    <tr>
                      <td colSpan={5} className="text-center py-4">
                        No exercise categories found.
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

export default ExerciseCategorys;