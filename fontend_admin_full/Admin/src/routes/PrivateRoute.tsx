import React from "react";
import { Navigate, Outlet } from "react-router-dom";

interface PrivateRouteProps {
  roles?: string[];
}

/**
 * Private Route forces the authorization before the route can be accessed
 */
const PrivateRoute: React.FC<PrivateRouteProps> = ({ roles }) => {
  const storedUser = localStorage.getItem("authUser");
  const loggedInUser = storedUser ? JSON.parse(storedUser) : null;

  if (!loggedInUser || !loggedInUser.token) {
    // Not logged in
    return <Navigate to="/admin/auth/login" replace />;
  }

  if (roles && roles.length > 0 && !roles.includes(loggedInUser.role)) {
    // Role not authorized
    return <Navigate to={{ pathname: "/admin/product/products" }} />;;
  }

  // Authorized
  return <Outlet />;
};

export default PrivateRoute;
