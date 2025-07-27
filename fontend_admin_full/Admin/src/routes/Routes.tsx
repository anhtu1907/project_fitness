import React from "react";
import { Navigate, Route, Routes } from "react-router-dom";

// redux
import { RootState } from "../redux/store";
import { useSelector } from "react-redux";

// All layouts containers
import DefaultLayout from "../layouts/Default";
import VerticalLayout from "../layouts/Vertical";

// Route lists
import { authProtectedFlattenRoutes, publicProtectedFlattenRoutes } from ".";

const AllRoutes = () => {
  const { Layout } = useSelector((state: RootState) => ({
    Layout: state.Layout,
  }));

  const isAuthenticated = () => {
    const user = localStorage.getItem("authUser");
    return !!user && JSON.parse(user).token;
  };

  return (
    <Routes>
      {/* Public Routes */}
      {(publicProtectedFlattenRoutes || []).map((route, idx) => (
        <Route
          key={idx}
          path={route.path}
          element={
            <DefaultLayout layout={Layout}>
              {route.element}
            </DefaultLayout>
          }
        />
      ))}

      {/* Authenticated Routes */}
      {(authProtectedFlattenRoutes || []).map((route, idx) => (
        <Route
          key={idx}
          path={route.path}
          element={
            isAuthenticated() ? (
              <VerticalLayout >
                {route.element}
              </VerticalLayout>
            ) : (
              <Navigate
                to={`/admin/auth/login?next=${route.path}`}
                replace
              />
            )
          }
        />
      ))}
    </Routes>
  );
};

export default AllRoutes;
