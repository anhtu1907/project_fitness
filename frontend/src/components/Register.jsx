import React from "react";
import { Link } from "react-router-dom";
import AuthLayout from "../layouts/AuthLayout";
import RegisterForm from "../components/auth/RegisterForm";

const Register = () => {
  return (
    <AuthLayout
      authTitle="Sign Up"
      helpText="Create your account to access our fitness platform."
      bottomLinks={
        <p className="text-gray-500 text-center text-sm">
          Already have an account?
          <Link to="/login" className="text-primary ms-1 font-semibold">
            Login
          </Link>
        </p>
      }
    >
      <RegisterForm />
    </AuthLayout>
  );
};

export default Register;