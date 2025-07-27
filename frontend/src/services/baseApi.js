import axios from "axios";

const base_url = "http://localhost:8080";

// api form

const api = axios.create({
  baseURL: base_url,
  headers: {
    "Content-Type": "application/json",
  },
  withCredentials: true,
});

const apiAuth = axios.create({
  baseURL: base_url,
  headers: {
    "Content-Type": "application/json",
  },
  withCredentials: true,
});

apiAuth.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("authToken");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// get image
const apiResource = (image_id) => axios.get(base_url + "/resources/" + image_id , {
  responseType: 'blob',
  headers: {
    "Accept": "image/*",
  },
  withCredentials: true,
});

// api.interceptors.response.use(
//   (response) => {
//     return response;
//   },
//   (error) => {
//     // Handle common errors
//     if (error.response?.status === 401) {
//       // Handle unauthorized access
//       localStorage.removeItem('authToken');
//       // Redirect to login page or handle as needed
//     }
//     return Promise.reject(error);
//   }
// );


export { api, apiAuth, apiResource };

export const successResponse = (result) =>  ({
  success: true,
  data: result.data.data
});

export const failResponse = (error) => ({
  success: false,
  errors: error.response.data.errors
});


// Api Response template
// success: true | false
// code: 400, 401, ..
// message: "User Created",..
// errors: ["Exception": "...",..]
// export const createApiResponse = (success, code, message, data = null) => ({
//   success,
//   code,
//   message,
//   data
// });

// export const createApiError = (success, code, errors = []) => ({
//   success,
//   code,
//   errors
// });
