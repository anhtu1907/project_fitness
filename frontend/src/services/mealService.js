import {apiAuth} from "./baseApi";

const API_BASE = `/api/meal`;

// 🍱 Meals
export const getAllMeals = async () => await apiAuth.get(`${API_BASE}`);

// 🏷️ Category & Subcategory
export const getAllMealCategory = async () => await apiAuth.get(`${API_BASE}/category`);
export const getAllMealSubCategory = async () => await apiAuth.get(`${API_BASE}/category/sub`);

// 🔍 Search by meal name
export const searchMealByName = async (mealName) =>
  await apiAuth.get(`${API_BASE}/search`, { params: { mealName } });
