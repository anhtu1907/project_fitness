import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import LoginImage from "../../assets/images/login_image.jpg";
import { Link, useNavigate } from "react-router-dom";
import { getUserByUsername, loginUser } from "../../services/userService";
import { useNotification } from "../ui/Notification";
import useUserStore from "../../stores/useUserStore";

const LoginForm = () => {
  const { setUser } = useUserStore();
  const navigate = useNavigate();
  const { showNotification, NotificationContainer } = useNotification();
  // handle Login action
  const handleLogin = async (values, { setSubmitting }) => {
    const requestData = {
      username: values.username,
      password: values.password,
    };

    // login to get token

    const tokenResult = await loginUser(requestData);
    if (tokenResult.success) {
      const token = tokenResult.data.token;
      localStorage.setItem("authToken", token);

      // get username and role from User by username
      
      const userResult = await getUserByUsername(requestData.username);
      if (userResult.success) {
        const user = {
          username: userResult?.data.username,
          role: userResult?.data.role.role,
          id: userResult?.data.id
        };
        setUser(user);

        showNotification(
          `Login successful! Welcome ${requestData.username}`,
          "success",
          2000
        );

        setTimeout(() => {
          navigate("/");
        }, 2000);
      } else {
        showNotification(
          `Can't not get role of account: ${requestData.username}\n
          ${userResult.errors}
          `,
          "warning",
          2000
        );
      }
    } else {
      // console.log(JSON.stringify(tokenResult?.errors))
      showNotification(
        "Login failed,\nPlease check username and password again!",
        "error"
      );
      setSubmitting(false);
    }
  };
  return (
    <>
      <NotificationContainer />
      {/* Card Container */}
      {/* Form */}
      <Formik
        initialValues={{ username: "", password: "" }}
        validationSchema={Yup.object({
          username: Yup.string().required("Username is required"),
          password: Yup.string().required("Password is required"),
        })}
        onSubmit={handleLogin}
      >
        <Form className="space-y-6 mt-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Username
            </label>
            <Field
              name="username"
              type="text"
              placeholder="Enter your username"
              className="w-full px-4 py-2 border border-gray-300 rounded-md bg-blue-50 focus:outline-none"
            />
            <ErrorMessage
              name="username"
              component="div"
              className="text-red-600 text-sm mt-1"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Password
            </label>
            <Field
              name="password"
              type="password"
              placeholder="Enter your password"
              className="w-full px-4 py-2 border border-gray-300 rounded-md bg-blue-50 focus:outline-none"
            />
            <ErrorMessage
              name="password"
              component="div"
              className="text-red-600 text-sm mt-1"
            />
          </div>

          <div className="flex items-center justify-between">
            <label className="flex items-center text-sm text-gray-600">
              <Field
                type="checkbox"
                name="remember"
                className="form-checkbox rounded text-blue-500"
              />
              <span className="ml-2">Remember me</span>
            </label>
            <Link
              to="/recover-password"
              className="text-sm text-blue-600 underline"
            >
              Forget Password?
            </Link>
          </div>

          <button
            type="submit"
            className="w-full p-3 font-semibold text-white bg-blue-600 rounded-md hover:bg-blue-700 transition"
          >
            Log In
          </button>
        </Form>
      </Formik>
    </>
  );
};

export default LoginForm;
