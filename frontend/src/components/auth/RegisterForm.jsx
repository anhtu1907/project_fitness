import React from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import LoginImage from "../../assets/images/login_image.jpg";
import { Link, useNavigate } from "react-router-dom";
import { createUser } from "../../services/userService";
import { useNotification } from "../ui/Notification";

function RegisterForm() {
  const navigate = useNavigate();
  const { showNotification, NotificationContainer } = useNotification();

  // handle Resister Action
  const handleRegister = async (values, { setSubmitting }) => {
    const userData = {
      username: values.username,
      password: values.password,
      email: values.email,
      firstName: values.firstName,
      lastName: values.lastName,
      gender: values.gender == "male" ? 1 : 0,
      phone: values.phone,
      dob: values.dob,
      address: values.address,
    };

    const resultCreate = await createUser(userData);
    if (resultCreate.success) {
      showNotification(
        `Hello ${resultCreate?.firstName} ${resultCreate?.lastName},\n
        Please, go to your email(${resultCreate?.email}) to complete created account!`,
        "warning",
        5000
      );
      navigate("/login");
    } else {
      const exception = resultCreate.errors?.Exception;
      console.log(exception);
      showNotification(`Please check your input data!\n${exception}`, "error");
      setSubmitting(false);
    }
  };

  return (
    <>
      <NotificationContainer />
       <Formik
        initialValues={{
          username: "",
          password: "",
          confirmPassword: "",
          email: "",
          firstName: "",
          lastName: "",
          phone: "",
          address: "",
          dob: "",
          gender: "",
          agreeTerms: false,
        }}
        validationSchema={Yup.object({
          username: Yup.string().min(3).max(30).required("Username is required"),
          password: Yup.string().min(6).required("Password is required"),
          confirmPassword: Yup.string()
            .oneOf([Yup.ref("password")], "Passwords must match")
            .required("Confirm password is required"),
          email: Yup.string().email().required("Email is required"),
          firstName: Yup.string().required("First name is required"),
          lastName: Yup.string().required("Last name is required"),
          phone: Yup.string().matches(/^[0-9]{10,11}$/).required("Phone is required"),
          address: Yup.string().min(5).required("Address is required"),
          gender: Yup.string().oneOf(["male", "female"]).required("Gender is required"),
          dob: Yup.date().max(new Date()).required("Date of birth is required"),
          agreeTerms: Yup.boolean().oneOf([true], "You must agree to the terms"),
        })}
        onSubmit={handleRegister}
      >
        <Form className="space-y-4 mt-4">
          <Field name="username" placeholder="Username" className="input" />
          <ErrorMessage name="username" component="div" className="text-red-600 text-sm" />

          <Field name="email" type="email" placeholder="Email" className="input" />
          <ErrorMessage name="email" component="div" className="text-red-600 text-sm" />

          <Field name="password" type="password" placeholder="Password" className="input" />
          <ErrorMessage name="password" component="div" className="text-red-600 text-sm" />

          <Field name="confirmPassword" type="password" placeholder="Confirm Password" className="input" />
          <ErrorMessage name="confirmPassword" component="div" className="text-red-600 text-sm" />

          <Field name="firstName" placeholder="First Name" className="input" />
          <ErrorMessage name="firstName" component="div" className="text-red-600 text-sm" />

          <Field name="lastName" placeholder="Last Name" className="input" />
          <ErrorMessage name="lastName" component="div" className="text-red-600 text-sm" />

          <Field name="phone" placeholder="Phone" className="input" />
          <ErrorMessage name="phone" component="div" className="text-red-600 text-sm" />

          <Field name="address" placeholder="Address" className="input" />
          <ErrorMessage name="address" component="div" className="text-red-600 text-sm" />

          <div className="flex flex-col gap-2 md:flex-row md:items-center md:gap-4">
            {/* Gender section */}
            <div className="flex gap-4 w-full md:w-1/2">
              <label className="flex items-center">
                <Field type="radio" name="gender" value="male" className="mr-2" />
                Male
              </label>
              <label className="flex items-center">
                <Field type="radio" name="gender" value="female" className="mr-2" />
                Female
              </label>
            </div>

            {/* DOB section */}
            <div className="w-full md:w-1/2">
              <Field name="dob" type="date" className="input w-full" />
            </div>
          </div>

          {/* Error messages */}
          <div className="flex flex-col md:flex-row md:gap-4">
            <ErrorMessage name="gender" component="div" className="text-red-600 text-sm w-full md:w-1/2" />
            <ErrorMessage name="dob" component="div" className="text-red-600 text-sm w-full md:w-1/2" />
          </div>

          <label className="text-sm text-gray-600 flex items-center">
            <Field type="checkbox" name="agreeTerms" className="mr-2" />
            I agree to the terms and conditions
          </label>
          <ErrorMessage name="agreeTerms" component="div" className="text-red-600 text-sm" />

          <button
            type="submit"
            className="w-full p-3 font-semibold text-white bg-blue-600 rounded-md hover:bg-blue-700 transition"
          >
            Sign Up
          </button>
        </Form>
      </Formik>
    </>
  );
}

export default RegisterForm;
