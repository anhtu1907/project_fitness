import { all, fork, put, takeEvery, call } from "redux-saga/effects";
import { SagaIterator } from "@redux-saga/core";

// helpers
import {
  login as loginApi,
  logout as logoutApi,
  forgotPassword as forgotPasswordApi,
} from "../../helpers/api/auth";

// actions
import { authApiResponseSuccess, authApiResponseError } from "./actions";

// constants
import { AuthActionTypes } from "./constants";

function mapUserData(apiData: any) {
  const decoded = apiData.token ? parseJwt(apiData.token) : {};
  let roles: string[] = [];
  let permissions: string[] = [];

  if (Array.isArray(decoded?.authorities)) {
    roles = decoded.authorities.filter((r: string) => r.startsWith("ROLE_"));
    permissions = decoded.authorities.filter((r: string) => !r.startsWith("ROLE_"));
  } else if (typeof decoded?.authorities === "string") {
    const arr = decoded.authorities.split(" ");
    roles = arr.filter((r: string) => r.startsWith("ROLE_"));
    permissions = arr.filter((r: string) => !r.startsWith("ROLE_"));
  } else if (Array.isArray(decoded?.roles)) {
    roles = decoded.roles.filter((r: string) => r.startsWith("ROLE_"));
    permissions = decoded.roles.filter((r: string) => !r.startsWith("ROLE_"));
  } else if (typeof decoded?.roles === "string") {
    const arr = decoded.roles.split(" ");
    roles = arr.filter((r: string) => r.startsWith("ROLE_"));
    permissions = arr.filter((r: string) => !r.startsWith("ROLE_"));
  }

  return {
    token: apiData.token,
    refreshToken: apiData.refreshToken,
    authenticated: apiData.authenticated,
    role: roles.length === 1 ? roles[0] : roles,
    permissions,
  };
}

function parseJwt(token: string): any {
  try {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split("")
        .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
        .join("")
    );
    return JSON.parse(jsonPayload);
  } catch {
    return {};
  }
}

interface UserData {
  payload: {
    username: string;
    password: string;
    fullname?: string;
    email?: string;
  };
  type: string;
}

/**
 * Login the user
 */
function* login({ payload: { username, password } }: UserData): SagaIterator {
  try {
    const response = yield call(loginApi, { username, password });

    if (response.data && response.data.success === false && response.data.errors?.Exception) {
      yield put(
        authApiResponseError(
          AuthActionTypes.LOGIN_USER,
          response.data.errors.Exception
        )
      );
      localStorage.removeItem("authUser");
      return;
    }

    const apiData = response.data.data;
    const user = mapUserData(apiData);

    const decoded = parseJwt(user.token);
    const authorities: string = decoded?.authorities || decoded?.roles || "";

    if (
      !authorities.includes("ROLE_ADMIN") &&
      !authorities.includes("ROLE_MODERATOR")&&
      !authorities.includes("ROLE_MANAGER")
    ) {
      yield put(
        authApiResponseError(
          AuthActionTypes.LOGIN_USER,
          "Access denied. You do not have permission to access this application."
        )
      );
      localStorage.removeItem("authUser");
      return;
    }

    localStorage.setItem("authUser", JSON.stringify(user)); // user đã có trường role
    yield put(authApiResponseSuccess(AuthActionTypes.LOGIN_USER, user));
  } catch (error: any) {
    yield put(authApiResponseError(AuthActionTypes.LOGIN_USER, "Login failed. Please check your credentials."));
    localStorage.removeItem("authUser");
  }
}

/**
 * Logout the user
 */
function* logout(): SagaIterator {
  try {
    const userData = JSON.parse(localStorage.getItem("authUser") || "null");
    const refreshToken = userData?.refreshToken;
    if (refreshToken) yield call(logoutApi, refreshToken);
  } catch (error) {}
  localStorage.removeItem("authUser");
  yield put(authApiResponseSuccess(AuthActionTypes.LOGOUT_USER, {}));
}

/**
 * Forgot password
 */
function* forgotPassword({ payload: { username } }: UserData): SagaIterator {
  try {
    const response = yield call(forgotPasswordApi, username);
    yield put(
      authApiResponseSuccess(AuthActionTypes.FORGOT_PASSWORD, response.data)
    );
  } catch (error: any) {
    yield put(authApiResponseError(AuthActionTypes.FORGOT_PASSWORD, error));
  }
}

export function* watchLoginUser() {
  yield takeEvery(AuthActionTypes.LOGIN_USER, login);
}

export function* watchLogout() {
  yield takeEvery(AuthActionTypes.LOGOUT_USER, logout);
}

export function* watchForgotPassword(): any {
  yield takeEvery(AuthActionTypes.FORGOT_PASSWORD, forgotPassword);
}

function* authSaga() {
  yield all([
    fork(watchLoginUser),
    fork(watchLogout),
    fork(watchForgotPassword),
  ]);
}

export default authSaga;