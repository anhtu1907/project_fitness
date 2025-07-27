import LoginForm from "../components/auth/LoginForm";
import RegisterForm from "../components/auth/RegisterForm";
import AuthLayout from "../layouts/AuthLayout";

function AuthPage({ mode }) {
  return (
    <AuthLayout>
      {mode === "login" ? <LoginForm /> : <RegisterForm />}
    </AuthLayout>
  );
}

export default AuthPage;
