import {apiAuth} from "./baseApi";

const API_BASE = `/api/exercise`;

// 🧘 Exercises
export const getAllExercise = async () => await apiAuth.get(`${API_BASE}`);

// 🏷️ Category & Subcategory
export const getAllCategory = async () => await apiAuth.get(`${API_BASE}/category`);
export const getAllSubCategory = async () => await apiAuth.get(`${API_BASE}/category/sub`);

// 🔍 Search SubCategory
export const searchSubCategory = async (subCategoryName) =>
  await apiAuth.get(`${API_BASE}/search`, { params: { subCategoryName } });
