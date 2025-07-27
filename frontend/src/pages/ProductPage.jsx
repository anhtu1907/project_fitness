import React, { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import MainLayout from "../layouts/MainLayout";
import LinkCard from "../components/products/LinkCard";
import {
  getECategories,
  getProductCards,
  getSCategories,
} from "../services/productService";

function ProductPage() {
  const [products, setProducts] = useState([]);
  const [activeTab, setActiveTab] = useState("tab-e"); // tab-e (equipment) | tab-s (supplement)

  const [categories, setCategories] = useState([]); // Full category objects with {id, name}
  const [selectedCategoryIds, setSelectedCategoryIds] = useState([]); // Just store IDs

  const [filteredProducts, setFilteredProducts] = useState([]);
  const [name, setName] = useState(""); // search
  const [loading, setLoading] = useState(true);

  // Api
  const fetchCards = async () => {
    const result = await getProductCards();
    return result.data;
  };

  const fetchECategories = async () => {
    const result = await getECategories();
    return result.data;
  };

  const fetchSCategories = async () => {
    const result = await getSCategories();
    return result.data;
  };

  // get category names from Ids
  const getCategoryNamesByIds = (categoryIds) => {
    if (!categoryIds || !Array.isArray(categoryIds) || !categories?.length) {
      return [];
    }

    return categoryIds.map((id) => {
      const category = categories.find(
        (cat) => cat.id === id || cat.categoryId === id
      );
      return category?.name;
    });
  };

  // search by Name
  const searchByName = (products, name) => {
    if (name === "") {
      return products;
    }

    return products.filter((p) =>
      p.name.toLowerCase().includes(name.toLowerCase())
    );
  };

  const handleSearchChange = (e) => {
    setName(e.target.value);
  };

  const clearSearch = () => {
    setName("");
  };

  // Category selection
  const clearCategories = () => {
    setSelectedCategoryIds([]);
  };

  const toggleCategory = (categoryId) => {
    setSelectedCategoryIds((prev) =>
      prev.includes(categoryId)
        ? prev.filter((id) => id !== categoryId)
        : [...prev, categoryId]
    );
  };

  // filter products
  const filterProducts = (products, selectedIds, name = "") => {
    let filtered = products;

    // filter by name
    if (name !== "") {
      filtered = searchByName(filtered, name);
    }

    // filter by categories
    if (selectedIds.length > 0) {
      filtered = filtered.filter((product) => {
        if (!product.categoryIds || !Array.isArray(product.categoryIds)) {
          return false;
        }

        return product.categoryIds.some((id) => selectedIds.includes(id));
      });
    }

    return filtered;
  };

  useEffect(() => {
    const fetchAllProducts = async () => {
      try {
        setLoading(true);

        const allProducts = await fetchCards();
        setProducts(allProducts);
      } catch (error) {
        console.error("Error fetching products:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchAllProducts();
  }, []);

  useEffect(() => {
    if (products.length === 0) return;

    setLoading(true);

    const filteredByType = products.filter((p) =>
      activeTab === "tab-e" ? p.type === "equipment" : p.type === "supplement"
    );
    const loadCategoriesAndFilter = async () => {
      try {
        // Load categories based on the active tab
        let categoryData = [];
        if (activeTab === "tab-e") {
          categoryData = await fetchECategories();
        } else {
          categoryData = await fetchSCategories();
        }

        setCategories(categoryData);

        // Finally, apply filters (name and category)
        setFilteredProducts(
          filterProducts(filteredByType, selectedCategoryIds, name)
        );
      } catch (error) {
        console.error("Error loading product data:", error);
        setCategories([]);
        setFilteredProducts([]);
      } finally {
        setLoading(false);
      }
    };

    loadCategoriesAndFilter();
  }, [products, activeTab, selectedCategoryIds, name]);

  return (
    <MainLayout>
      <div className="bg-white p-6 m-3 space-y-10 md:p-5">
        {/* Tab Switch */}
        <div className="flex flex-col justify-between space-y-5 md:flex-row md:space-y-0">
          <div className="flex border-b border-gray-200">
            <button
              className={`flex-1 py-2 text-center font-bold ${
                activeTab === "tab-e"
                  ? "text-blue-600 border-b-2 border-blue-600"
                  : "text-gray-600"
              }`}
              onClick={() => setActiveTab("tab-e")}
            >
              <FontAwesomeIcon
                icon={["fas", "toolbox"]}
                size="2x"
                className="mx-1"
              />
              Equipment
            </button>
            <button
              className={`flex-1 py-2 text-center font-bold ${
                activeTab === "tab-s"
                  ? "text-rose-700 border-b-2 border-rose-700"
                  : "text-gray-600"
              }`}
              onClick={() => setActiveTab("tab-s")}
            >
              <FontAwesomeIcon
                icon={["fas", "pills"]}
                size="2x"
                className="mx-1"
              />
              Dietary Supplement
            </button>
          </div>
        </div>

        {/* Search box */}
        <div className="flex flex-col justify-between space-y-5 md:flex-row md:space-y-0">
          <div className="flex justify-between border-b">
            <input
              value={name}
              onChange={handleSearchChange}
              type="text"
              className="ml-6 border-none md:w-80 placeholder:font-thin focus:outline-none"
              placeholder="Search by name"
            />
            <div className="flex items-center space-x-2">
              {name && (
                <button
                  onClick={clearSearch}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <FontAwesomeIcon icon={["fas", "xmark"]} size="2x" />
                </button>
              )}
            </div>
          </div>
        </div>

        {/* Filter Categories */}
        <div className="flex items-center justify-center py-4 md:py-8 flex-wrap">
          <button
            type="button"
            onClick={clearCategories}
            className={`border rounded-full text-base font-medium px-5 py-2.5 text-center me-3 mb-3 focus:ring-4 focus:outline-none ${
              selectedCategoryIds.length === 0
                ? "text-white bg-blue-700 border-blue-600 hover:bg-blue-800"
                : "text-blue-700 hover:text-white border-blue-600 bg-white hover:bg-blue-700"
            }`}
          >
            All categories
          </button>
          {categories && categories.map((category) => (
            <button
              key={category.id}
              type="button"
              onClick={() => toggleCategory(category.id)}
              className={`border rounded-full text-base font-medium px-5 py-2.5 text-center me-3 mb-3 focus:ring-4 focus:outline-none ${
                selectedCategoryIds.includes(category.id)
                  ? "text-white bg-gray-800 border-gray-800 hover:bg-gray-900"
                  : "text-gray-900 border-gray-300 bg-white hover:border-gray-400 hover:bg-gray-50"
              }`}
            >
              {category.name.charAt(0).toUpperCase() +
                category.name.slice(1).replace("-", " ")}
            </button>
          ))}
        </div>

        {/* Selected Categories Display */}
        {selectedCategoryIds.length > 0 && (
          <div className="flex items-center space-x-2 py-2">
            <span className="text-sm font-medium text-gray-700">
              Active filters:
            </span>
            {selectedCategoryIds.map((categoryId) => {
              const category = categories.find((c) => c.id === categoryId);
              return category ? (
                <span
                  key={categoryId}
                  className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
                >
                  {category.name.charAt(0).toUpperCase() +
                    category.name.slice(1).replace("-", " ")}
                  <button
                    type="button"
                    onClick={() => toggleCategory(categoryId)}
                    className="ml-1 text-blue-400 hover:text-blue-600"
                  >
                    ×
                  </button>
                </span>
              ) : null;
            })}
          </div>
        )}

        {/* List Card */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {loading ? (
            <div className="col-span-full text-center py-8">
              <p className="text-gray-500">Loading products...</p>
            </div>
          ) : filteredProducts.length > 0 ? (
            filteredProducts.map((p, index) => (
              <LinkCard
                key={p.id || index}
                type={p.type}
                id={p.id}
                name={p.name}
                image={p.image}
                price={p.price}
                discount={p.discount}
                stock={p.stock}
                rating={p.rating}
                detailId={p.detailId}
                categories={getCategoryNamesByIds(p.categoryIds)}
              />
            ))
          ) : (
            <div className="col-span-full text-center py-8">
              <p className="text-gray-500">
                {name || selectedCategoryIds.length > 0
                  ? "No products found matching your criteria"
                  : "No products found"}
              </p>
            </div>
          )}
        </div>

        {/* Pagination section remains the same */}
      </div>
    </MainLayout>
  );
}

export default ProductPage;
