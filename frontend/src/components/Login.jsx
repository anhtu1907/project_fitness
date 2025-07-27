import React from "react";
import { Link } from "react-router-dom";
import AuthLayout from "../layouts/AuthLayout";
import LoginForm from "../components/auth/LoginForm"; // điều chỉnh đường dẫn nếu cần

const Login = () => {
  return (
    <AuthLayout
      authTitle="Sign In"
      helpText="Enter your email address and password to access admin panel."
      bottomLinks={
        <p className="text-gray-500 text-center text-sm">
          Don't have an account?
          <Link to="/register" className="text-primary ms-1 font-semibold">
            Register
          </Link>
        </p>
      }
    >
      <LoginForm />
    </AuthLayout>
  );
};

export default Login;
