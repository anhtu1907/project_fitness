import React, { useState, useEffect } from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import { getUserByUsername, updateUserById } from "../services/userService";
import useUserStore from "../stores/useUserStore";
import MainLayout from "../layouts/MainLayout";

const ProfilePage = () => {
  const [userProfile, setUserProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const { user } = useUserStore();

  const validationSchema = Yup.object({
    firstName: Yup.string().min(2, "First name must be at least 2 characters"),
    lastName: Yup.string().min(2, "Last name must be at least 2 characters"),
    email: Yup.string()
      .email("Invalid email address")
      .required("Email is required"),
    phone: Yup.string().matches(/^[0-9+\-\s()]+$/, "Invalid phone number"),
    address: Yup.string(),
    dob: Yup.date().max(new Date(), "Date of birth cannot be in the future"),
  });

  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        const result = await getUserByUsername(user.username);
        if (result && result.success) {
          setUserProfile(result.data);
        } else {
          console.log("API call failed:", result);
        }
      } catch (apiError) {
        console.log("API error:", apiError);
      }

      setLoading(false);
    };

    if (user?.username) {
      fetchUserProfile();
    }
  }, [user?.username]);

  const handleFormSubmit = async (values, { setSubmitting }) => {
    try {
      const userRequest = {
        password: userProfile.password,
        firstName: values.firstName,
        lastName: values.lastName,
        email: values.email,
        address: values.address,
        phone: values.phone,
        dob: values.dob
      };

      console.log("Updating profile with:", userRequest);

      const result = await updateUserById(userProfile.id, userRequest);

      if (result && result.success) {
        // Update local state with the response data
        setUserProfile((prev) => ({
          ...prev,
          ...result.data,
        }));

        setIsEditing(false);
        alert("Profile updated successfully!");
      } else {
        throw new Error(result?.errors || "Update failed");
      }
    } catch (error) {
      console.error("Error updating profile:", error);
      alert("Failed to update profile: " + (error.message || error));
    } finally {
      setSubmitting(false);
    }
  };

  const getDisplayName = () => {
    if (userProfile?.firstName && userProfile?.lastName) {
      return `${userProfile.firstName} ${userProfile.lastName}`;
    }
    return userProfile?.username || "";
  };

  const getInitials = () => {
    if (userProfile?.firstName && userProfile?.lastName) {
      return `${userProfile.firstName.charAt(0)}${userProfile.lastName.charAt(
        0
      )}`.toUpperCase();
    }
    return userProfile?.username?.charAt(0)?.toUpperCase() || "U";
  };

  const formatDateFromArray = (dateArray) => {
    if (Array.isArray(dateArray) && dateArray.length === 3) {
      const [year, month, day] = dateArray;
      return `${year}-${month.toString().padStart(2, "0")}-${day
        .toString()
        .padStart(2, "0")}`;
    }
    if (typeof dateArray === 'string') {
      return dateArray.split('T')[0]; // Handle ISO date strings
    }
    return dateArray || "";
  };

  if (loading) {
    return (
      <MainLayout>
        <div className="flex items-center justify-center min-h-screen">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600"></div>
        </div>
      </MainLayout>
    );
  }

  if (!userProfile) {
    return (
      <MainLayout>
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-center">
            <div className="text-red-400 text-6xl mb-4">⚠️</div>
            <div className="text-xl text-red-600">Failed to load profile</div>
            <button
              onClick={() => window.location.reload()}
              className="mt-4 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Try Again
            </button>
          </div>
        </div>
      </MainLayout>
    );
  }

  const initialValues = {
    firstName: userProfile.firstName || "",
    lastName: userProfile.lastName || "",
    email: userProfile.email || "",
    phone: userProfile.phone || "",
    address: userProfile.address || "",
    dob: formatDateFromArray(userProfile.dob),
  };

  return (
    <MainLayout>
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          {/* Profile Header */}
          <div className="bg-gradient-to-r from-sky-300 to-purple-800 rounded-lg shadow-lg overflow-hidden mb-8">
            <div className="px-6 py-8 sm:px-8">
              <div className="flex items-center space-x-6">
                <div className="h-20 w-20 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                  <span className="text-2xl font-bold text-black">
                    {getInitials()}
                  </span>
                </div>
                <div className="flex-1">
                  <h1 className="text-2xl font-bold text-black">
                    {getDisplayName()}
                  </h1>
                  <p className="text-blue-100">@{userProfile.username}</p>
                  <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-white bg-opacity-20 text-red-600 mt-2">
                    {userProfile.role?.role || 'User'}
                  </span>
                </div>
                <button
                  onClick={() => setIsEditing(!isEditing)}
                  className="bg-white bg-opacity-20 hover:bg-opacity-30 text-violet-800 px-4 py-2 rounded-lg transition-colors duration-200"
                >
                  {isEditing ? "Cancel" : "Edit Profile"}
                </button>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Profile Form */}
            <div className="lg:col-span-2">
              <div className="bg-white rounded-lg shadow p-6">
                <h2 className="text-xl font-semibold text-gray-900 mb-6">
                  Personal Information
                </h2>

                <Formik
                  initialValues={initialValues}
                  validationSchema={validationSchema}
                  onSubmit={handleFormSubmit}
                  enableReinitialize
                >
                  {({ isSubmitting, values }) => (
                    <Form className="space-y-6">
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">
                            First Name
                          </label>
                          <Field
                            name="firstName"
                            type="text"
                            disabled={!isEditing}
                            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                            placeholder="Enter first name"
                          />
                          <ErrorMessage
                            name="firstName"
                            component="div"
                            className="text-red-600 text-sm mt-1"
                          />
                        </div>

                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">
                            Last Name
                          </label>
                          <Field
                            name="lastName"
                            type="text"
                            disabled={!isEditing}
                            className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                            placeholder="Enter last name"
                          />
                          <ErrorMessage
                            name="lastName"
                            component="div"
                            className="text-red-600 text-sm mt-1"
                          />
                        </div>
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          Email Address
                        </label>
                        <Field
                          name="email"
                          type="email"
                          disabled={!isEditing}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                          placeholder="Enter email address"
                        />
                        <ErrorMessage
                          name="email"
                          component="div"
                          className="text-red-600 text-sm mt-1"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          Phone Number
                        </label>
                        <Field
                          name="phone"
                          type="tel"
                          disabled={!isEditing}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                          placeholder="Enter phone number"
                        />
                        <ErrorMessage
                          name="phone"
                          component="div"
                          className="text-red-600 text-sm mt-1"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          Address
                        </label>
                        <Field
                          name="address"
                          as="textarea"
                          rows="3"
                          disabled={!isEditing}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                          placeholder="Enter address"
                        />
                        <ErrorMessage
                          name="address"
                          component="div"
                          className="text-red-600 text-sm mt-1"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          Date of Birth
                        </label>
                        <Field
                          name="dob"
                          type="date"
                          disabled={!isEditing}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-50 disabled:text-gray-500"
                        />
                        <ErrorMessage
                          name="dob"
                          component="div"
                          className="text-red-600 text-sm mt-1"
                        />
                      </div>

                      {isEditing && (
                        <div className="flex space-x-4">
                          <button
                            type="submit"
                            disabled={isSubmitting}
                            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                          >
                            {isSubmitting ? "Saving..." : "Save Changes"}
                          </button>
                          <button
                            type="button"
                            onClick={() => setIsEditing(false)}
                            className="bg-gray-300 hover:bg-gray-400 text-gray-700 px-6 py-2 rounded-md transition-colors duration-200"
                          >
                            Cancel
                          </button>
                        </div>
                      )}
                    </Form>
                  )}
                </Formik>
              </div>
            </div>

            {/* Role & Permissions */}
            <div className="space-y-6">
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">
                  Account Information
                </h3>
                <div className="space-y-3">
                  <div>
                    <span className="text-sm font-medium text-gray-700">Username:</span>
                    <p className="text-gray-900">{userProfile.username}</p>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-700">Role:</span>
                    <div className="mt-1">
                      <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                        {userProfile.role?.role || 'User'}
                      </span>
                    </div>
                  </div>
                  {userProfile.role?.description && (
                    <div>
                      <span className="text-sm font-medium text-gray-700">Description:</span>
                      <p className="text-gray-600 text-sm mt-1">
                        {userProfile.role.description}
                      </p>
                    </div>
                  )}
                </div>
              </div>

              {userProfile.role?.permissions && userProfile.role.permissions.length > 0 && (
                <div className="bg-white rounded-lg shadow p-6">
                  <h3 className="text-lg font-semibold text-gray-900 mb-4">
                    Permissions
                  </h3>
                  <div className="space-y-2 max-h-96 overflow-y-auto">
                    {userProfile.role.permissions.map((permission, index) => (
                      <div
                        key={permission.id || index}
                        className="p-3 bg-gray-50 rounded-md"
                      >
                        <h4 className="text-sm font-medium text-gray-900">
                          {permission.permission?.replace(/_/g, " ") || 'Unknown Permission'}
                        </h4>
                        {permission.description && (
                          <p className="text-xs text-gray-600 mt-1">
                            {permission.description}
                          </p>
                        )}
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Additional Stats */}
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">
                  Account Stats
                </h3>
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Member since:</span>
                    <span className="text-sm font-medium text-gray-900">
                      {new Date().getFullYear()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Profile completion:</span>
                    <span className="text-sm font-medium text-green-600">
                      {(() => {
                        const fields = [
                          userProfile.firstName,
                          userProfile.lastName,
                          userProfile.email,
                          userProfile.phone,
                          userProfile.address,
                          userProfile.dob
                        ];
                        const completed = fields.filter(field => field && field.length > 0).length;
                        return Math.round((completed / fields.length) * 100);
                      })()}%
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
};

export default ProfilePage;
