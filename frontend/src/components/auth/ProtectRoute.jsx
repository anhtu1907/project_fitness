import { Navigate } from 'react-router-dom';
import useUserStore  from '../../stores/useUserStore';

const ProtectedRoute = ({ children, requiredRole, requiredPermissions = [] }) => {
  const { user, isAuthenticated } = useUserStore();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user.role !== requiredRole) {
    return <Navigate to="/unauthorized" replace />;
  }

  if (requiredPermissions.length > 0) {
    const hasPermission = requiredPermissions.every(permission =>
      user.permissions.includes(permission)
    );

    if (!hasPermission) {
      return <Navigate to="/unauthorized" replace />;
    }
  }

  return children;
};

export default ProtectedRoute;