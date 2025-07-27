import axios from "axios";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";
const AUTH_URL = `${API_BASE_URL}/auth`;

// Đăng nhập
export const login = (data: { username: string; password: string }) => {
  return axios.post(`${AUTH_URL}/login`, data, {
    headers: {
      "X-Device-Type": "DESKTOP",
    },
  });
};

// Đăng xuất
export const logout = (refreshToken: string) => {
  return axios.post(`${AUTH_URL}/logout`, { refreshToken });
};

// Làm mới token
export const refreshToken = (refreshToken: string) => {
  return axios.post(`${AUTH_URL}/refresh-token`, { refreshToken });
};

// Gửi email quên mật khẩu
export const forgotPassword = (email: string) => {
  return axios.post(`${AUTH_URL}/forgot-password`, { email });
};
