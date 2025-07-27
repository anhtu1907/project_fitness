import React, { useEffect, useState } from "react";
import MainLayout from "../layouts/MainLayout";
import { getAllMeals } from "../services/mealService";
import MealCard from "../components/MealCard";

function MealPage() {
  const [meals, setMeals] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await getAllMeals();
         console.log("✅ Dữ liệu trả về từ API:", res.data);
        setMeals(res.data);
        setFiltered(res.data);
      } catch (err) {
        console.error("Failed to fetch meals", err);
      }
    };
    fetchData();
  }, []);

  useEffect(() => {
    const s = search.toLowerCase().trim();
    const filteredList = meals.filter((m) =>
    m?.mealName?.toLowerCase().includes(s)
  );

    setFiltered(filteredList);
    setCurrentPage(1);
  }, [search, meals]);

  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const currentMeals = filtered.slice(startIndex, startIndex + itemsPerPage);

  const clearSearch = () => setSearch("");

  return (
    <MainLayout>
      <div className="p-4 bg-white min-h-screen">
        <div className="mb-6 flex justify-between items-center">
          <h1 className="text-2xl font-bold">Meals</h1>
          <div className="relative w-64">
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search meal..."
              className="border px-3 py-2 rounded-md w-full"
            />
            {search && (
              <button
                onClick={clearSearch}
                className="absolute right-2 top-2 text-gray-500 hover:text-red-500"
              >
                ×
              </button>
            )}
          </div>
        </div>

        {currentMeals.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {currentMeals.map((meal) => (
              <MealCard key={meal.id} meal={meal} />
            ))}
          </div>
        ) : (
          <div className="text-gray-500">No meals found.</div>
        )}

        {/* Pagination with < > */}
        {totalPages > 1 && (
          <div className="mt-6 flex justify-center items-center gap-2 flex-wrap">
            <button
              onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className={`px-3 py-1 rounded border ${currentPage === 1
                ? "bg-gray-200 text-gray-400 cursor-not-allowed"
                : "bg-white text-gray-700 hover:bg-gray-100"
                }`}
            >
              &lt;
            </button>

            {(() => {
              const pages = [];
              const createBtn = (page) => (
                <button
                  key={page}
                  onClick={() => setCurrentPage(page)}
                  className={`px-3 py-1 rounded border ${currentPage === page
                    ? "bg-blue-600 text-white"
                    : "bg-white text-gray-700 hover:bg-gray-100"
                    }`}
                >
                  {page}
                </button>
              );

              if (totalPages <= 6) {
                for (let i = 1; i <= totalPages; i++) {
                  pages.push(createBtn(i));
                }
              } else {
                pages.push(createBtn(1));
                if (currentPage > 3) pages.push(<span key="start-ellipsis">...</span>);
                const start = Math.max(2, currentPage - 1);
                const end = Math.min(totalPages - 1, currentPage + 1);
                for (let i = start; i <= end; i++) {
                  pages.push(createBtn(i));
                }
                if (currentPage < totalPages - 2) pages.push(<span key="end-ellipsis">...</span>);
                pages.push(createBtn(totalPages));
              }

              return pages;
            })()}

            <button
              onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
              disabled={currentPage === totalPages}
              className={`px-3 py-1 rounded border ${currentPage === totalPages
                ? "bg-gray-200 text-gray-400 cursor-not-allowed"
                : "bg-white text-gray-700 hover:bg-gray-100"
                }`}
            >
              &gt;
            </button>
          </div>
        )}
      </div>
    </MainLayout>
  );
}

export default MealPage;
