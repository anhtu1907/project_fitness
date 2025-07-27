import { api, successResponse, failResponse } from "./baseApi.js";

export const getProductCards = async() => {
  try {
    const result = await api.get("/api/productV2/cards");
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}

export const getECategories = async() => {
  try {
    const result = await api.get("/api/productV2/ecategory");
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}


export const getSCategories = async() => {
  try {
    const result = await api.get("/api/productV2/scategory");
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}

export const getEquipmentById = async(id) => {
  try {
    const result = await api.get(`/api/productV2/equipment/${id}`);
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}

export const getSupplementById = async(id) => {
  try {
    const result = await api.get(`/api/productV2/supplement/${id}`);
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}

export const getProductTopCards = async (limit) => {
  try {
    const result = await api.get(`/api/productV2/top/${limit}`);
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
}
