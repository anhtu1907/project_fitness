import axios, { AxiosRequestConfig, AxiosResponse } from "axios";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";

const axiosInstance = axios.create({
  baseURL: API_BASE_URL,
});

export class APICore {
  get = <T = any>(url: string, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> => {
    return axiosInstance.get(url, config);
  };

  create = <T = any>(url: string, data: any, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> => {
    return axiosInstance.post(url, data, config);
  };

  update = <T = any>(url: string, data: any, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> => {
    return axiosInstance.put(url, data, config);
  };

  delete = <T = any>(url: string, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> => {
    return axiosInstance.delete(url, config);
  };
}

export const isUserAuthenticated = (): boolean => {
  const user = localStorage.getItem("authUser");
  return !!user;
};

export const getLoggedInUser = (): any | null => {
  const user = localStorage.getItem("authUser");
  if (!user) return null;
  try {
    return JSON.parse(user);
  } catch {
    return null;
  }
};

export const setLoggedInUser = (user: any) => {
  if (user) {
    localStorage.setItem("authUser", JSON.stringify(user));
  } else {
    localStorage.removeItem("authUser");
  }
};

// Lấy access token và refresh token từ localStorage
function getAccessToken() {
  const user = localStorage.getItem("authUser");
  if (!user) return "";
  try {
    return JSON.parse(user)?.token || "";
  } catch {
    return "";
  }
}
function getRefreshToken() {
  const user = localStorage.getItem("authUser");
  if (!user) return "";
  try {
    return JSON.parse(user)?.refreshToken || "";
  } catch {
    return "";
  }
}
function setAccessToken(token: string) {
  const user = localStorage.getItem("authUser");
  if (!user) return;
  try {
    const obj = JSON.parse(user);
    obj.token = token;
    localStorage.setItem("authUser", JSON.stringify(obj));
  } catch {}
}

// Request interceptor: tự động gắn access token vào header
axiosInstance.interceptors.request.use(
  (config) => {
    const token = getAccessToken();
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor: tự động refresh token khi gặp 401
let isRefreshing = false;
let failedQueue: any[] = [];

function processQueue(error: any, token: string | null = null) {
  failedQueue.forEach(prom => {
    if (error) {
      prom.reject(error);
    } else {
      prom.resolve(token);
    }
  });
  failedQueue = [];
}

axiosInstance.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    if (
      error.response &&
      error.response.status === 401 &&
      !originalRequest._retry
    ) {
      if (isRefreshing) {
        return new Promise(function (resolve, reject) {
          failedQueue.push({ resolve, reject });
        })
          .then((token) => {
            originalRequest.headers["Authorization"] = "Bearer " + token;
            return axiosInstance(originalRequest);
          })
          .catch((err) => Promise.reject(err));
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        // Gọi API refresh token (giả sử endpoint là /auth/refresh)
        const refreshToken = getRefreshToken();
        const res = await axios.post(
          `${API_BASE_URL}/auth/refresh-token`,
          { refreshToken }
        );
        const newToken = res.data.data.token;
        setAccessToken(newToken);
        axiosInstance.defaults.headers.common["Authorization"] = "Bearer " + newToken;
        processQueue(null, newToken);
        return axiosInstance(originalRequest);
      } catch (err) {
        processQueue(err, null);
        localStorage.removeItem("authUser");
        window.location.href = "/admin/auth/login";
        return Promise.reject(err);
      } finally {
        isRefreshing = false;
      }
    }
    return Promise.reject(error);
  }
);