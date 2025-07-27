import { api, failResponse, successResponse } from "./baseApi";

export const getPromotions = async () => {
  try {
    const result = await api.get("/api/promotion");
    return successResponse(result);
  } catch (error) {
    return failResponse(error);
  }
};