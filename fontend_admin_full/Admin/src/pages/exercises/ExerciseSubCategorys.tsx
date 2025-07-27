import React, { useEffect, useState } from "react";
import { PageBreadcrumb } from "../../components";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();

type ExerciseSubCategory = {
  id: number;
  subCategoryName: string;
  subCategoryImage?: string;
  description: string;
};

const ExerciseSubCategorys = () => {
  const [subCategories, setSubCategories] = useState<ExerciseSubCategory[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchSubCategories();
  }, []);

  const fetchSubCategories = async () => {
    try {
      const res = await api.get("/api/admin/exercise-sub-category");
      setSubCategories(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name="Exercise Subcategories"
        title="Exercise Subcategories"
        breadCrumbItems={["Fitmate", "Exercise Subcategories", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Exercise Subcategory List</h4>
            <Link
              to="/admin/exercise/exercise-sub-category/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Subcategory
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
                    <th className="px-2 py-2 border">Description</th>
                    <th className="px-2 py-2 border">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {subCategories.map((s) => (
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
                      <td className="px-2 py-2 border">
                        <Link
                          to={`/admin/exercise/exercise-sub-category/edit/${s.id}`}
                          className="me-2 text-blue-600"
                          title="Edit"
                        >
                          <i className="mgc_edit_line text-lg"></i>
                        </Link>
                        <a
                          href={`/admin/exercise/exercise-sub-category/delete/${s.id}`}
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
                  {subCategories.length === 0 && (
                    <tr>
                      <td colSpan={5} className="text-center py-4">
                        No exercise subcategories found.
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

export default ExerciseSubCategorys;