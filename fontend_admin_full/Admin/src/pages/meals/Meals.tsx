import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const BASE_URL = config.API_URL;
const api = new APICore();
const PAGE_SIZE = 5;

type Meal = {
  id: number;
  mealName: string;
  mealImage?: string;
  weight: number;
  kcal: number;
  protein: number;
  fat: number;
  carbonhydrate: number;
  fiber: number;
  sugar: number;
  subCategoryIds: number[];
  timeOfDayIds: number[];
};

type Category = {
  id: number;
  categoryName: string;
};

type MealTime = {
  id: number;
  timeName: string; // hoặc mealTimeName nếu backend trả về như vậy
};

const Meals = () => {
  const [meals, setMeals] = useState<Meal[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [mealTimes, setMealTimes] = useState<MealTime[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);

  useEffect(() => {
    fetchMeals();
    api
      .get("/api/admin/meal-category")
      .then((res: any) => setCategories(res.data.data || []));
    api
      .get("/api/admin/meal-times")
      .then((res: any) => setMealTimes(res.data.data || []));
  }, []);

  const fetchMeals = async () => {
    try {
      const res = await api.get("/api/admin/meals");
      setMeals(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  const getCategoryNames = (ids: number[]) =>
    categories
      .filter((c) => ids.includes(c.id))
      .map((c) => c.categoryName)
      .join(", ");

  const getMealTimeNames = (ids: number[]) =>
    mealTimes
      .filter((t) => ids.includes(t.id))
      .map((t) => t.timeName)
      .join(", ");

  const totalPages = Math.ceil(meals.length / PAGE_SIZE);
  const pagedMeals = meals.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="Meals"
        title="Meals"
        breadCrumbItems={["Fitmate", "Meals"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Meal List</h4>
            <Link
              to="/admin/meal/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Meal
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
                      <th className="px-2 py-2 border">Weight</th>
                      <th className="px-2 py-2 border">Kcal</th>
                      <th className="px-2 py-2 border">Protein</th>
                      <th className="px-2 py-2 border">Fat</th>
                      <th className="px-2 py-2 border">Carb</th>
                      <th className="px-2 py-2 border">Fiber</th>
                      <th className="px-2 py-2 border">Sugar</th>
                      <th className="px-2 py-2 border">Category</th>
                      <th className="px-2 py-2 border">TimeOfDay</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedMeals.map((m) => (
                      <tr key={m.id}>
                        <td className="px-2 py-2 border">{m.id}</td>
                        <td className="px-2 py-2 border">
                          {m.mealImage ? (
                            (() => {
                              const imageUrl = m.mealImage.startsWith("http")
                                ? m.mealImage
                                : BASE_URL + "/resources/" + m.mealImage;

                              const isImage = /\.(jpg|jpeg|png|webp|gif)$/i.test(imageUrl);

                              return isImage ? (
                                <img
                                  src={imageUrl}
                                  alt={m.mealName}
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
                        <td className="px-2 py-2 border">{m.mealName}</td>
                        <td className="px-2 py-2 border">{m.weight}</td>
                        <td className="px-2 py-2 border">{m.kcal}</td>
                        <td className="px-2 py-2 border">{m.protein}</td>
                        <td className="px-2 py-2 border">{m.fat}</td>
                        <td className="px-2 py-2 border">{m.carbonhydrate}</td>
                        <td className="px-2 py-2 border">{m.fiber}</td>
                        <td className="px-2 py-2 border">{m.sugar}</td>
                        <td className="px-2 py-2 border">
                          {getCategoryNames(m.subCategoryIds)}
                        </td>
                        <td className="px-2 py-2 border">
                          {getMealTimeNames(m.timeOfDayIds)}
                        </td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/meal/edit/${m.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <a
                            href={`/admin/meal/delete/${m.id}`}
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
                    {pagedMeals.length === 0 && (
                      <tr>
                        <td colSpan={13} className="text-center py-4">
                          No meals found.
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

export default Meals;