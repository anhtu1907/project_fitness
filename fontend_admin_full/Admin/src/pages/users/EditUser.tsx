import React, { useEffect, useState } from "react";
import { FormInput, PageBreadcrumb } from "../../components";
import { useParams, useNavigate } from "react-router-dom";
import {
  fetchUserById,
  updateUser,
  UserResponse,
  UserUpdateRequest,
  fetchRoles,
  RoleOption,
} from "./data";
import Select from "react-select";
import { toast } from "react-hot-toast";


// Custom Alert Card UI
const DescriptionAlert = () => {
  return (
    <div className="card mb-6">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Important Notice</h4>
        </div>
      </div>
      <div className="p-6">
        <div className="space-y-4">
          <div
            className="bg-yellow-50 border border-yellow-200 rounded-md p-4"
            role="alert"
          >
            <div className="flex">
              <div className="flex-shrink-0">
                <i className="mgc_information_line text-xl text-yellow-700"></i>
              </div>
              <div className="ms-4">
                <h3 className="text-sm text-yellow-800 font-semibold">
                  Editing user information may affect access
                </h3>
                <div className="mt-1 text-sm text-yellow-700">
                  Changes to <strong>email</strong>, <strong>role</strong>, or{" "}
                  <strong>date of birth</strong> may impact user permissions,
                  identity, and system notifications. Please review carefully
                  before submitting.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

const EditUser = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [user, setUser] = useState<UserResponse | null>(null);
  const [form, setForm] = useState<UserUpdateRequest>({});
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [roleOptions, setRoleOptions] = useState<RoleOption[]>([]);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [confirmName, setConfirmName] = useState("");
  const [confirmError, setConfirmError] = useState("");

  useEffect(() => {
    if (id) {
      setLoading(true);
      fetchUserById(id)
        .then((u) => {
          setUser(u);
          setForm({
            firstName: u.firstName || "",
            lastName: u.lastName || "",
            email: u.email || "",
            phone: u.phone || "",
            address: u.address || "",
            dob:
              Array.isArray(u.dob) && u.dob.length === 3
                ? `${u.dob[0]}-${String(u.dob[1]).padStart(2, "0")}-${String(
                    u.dob[2]
                  ).padStart(2, "0")}`
                : typeof u.dob === "string"
                ? u.dob
                : "",
            roleName: u.role?.role || "",
            active: u.active,
          });

          // Show one-time toast warning
          toast("Editing user info may affect access rights", {
            icon: "⚠️",
            duration: 5000,
            style: {
              background: "#fef3c7",
              color: "#92400e",
            },
          });
        })
        .catch(() => setError("User not found"))
        .finally(() => setLoading(false));
    }
  }, [id]);

  useEffect(() => {
    fetchRoles().then((roles) => {
      const filtered = roles.filter(
        (opt) => opt.value !== "ADMIN" && opt.value !== "ROLE_ADMIN"
      );
      setRoleOptions(filtered);
    });
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleRoleChange = (selected: RoleOption | null) => {
    setForm({ ...form, roleName: selected ? selected.value : undefined });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setConfirmOpen(true); // Mở popup xác nhận
  };

  const handleConfirmUpdate = async () => {
    if (confirmName.trim() !== user?.username) {
      setConfirmError("Username does not match. Please enter the correct username.");
      return;
    }
    setConfirmError("");
    setConfirmOpen(false);
    setSaving(true);
    setError(null);
    try {
      await updateUser(id!, form);
      toast.success("User updated successfully");
      navigate("/admin/manage-users/users");
    } catch (err: any) {
      setError("Update failed");
      toast.error("Failed to update user");
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <div className="p-6 text-center">Loading...</div>;
  if (error) return <div className="p-6 text-center text-red-500">{error}</div>;
  if (!user) return null;

  return (
    <>
      <PageBreadcrumb
        title="Edit User"
        name="Edit User"
        breadCrumbItems={["Fitmate", "Users", "Edit User"]}
      />

      <div className="col-span-12 mx-auto">
        <div className="card">
          <div className="card-header">
            <h4 className="card-title">Edit User</h4>
          </div>
          <div className="p-6">
            {/* Alert UI */}
            <DescriptionAlert />

            <form onSubmit={handleSubmit}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <FormInput
                    label="First Name"
                    name="firstName"
                    value={form.firstName}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div>
                  <FormInput
                    label="Last Name"
                    name="lastName"
                    value={form.lastName}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div className="md:col-span-2">
                  <FormInput
                    label="Email"
                    name="email"
                    type="email"
                    value={form.email}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div>
                  <FormInput
                    label="Phone"
                    name="phone"
                    value={form.phone}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div>
                  <FormInput
                    label="Address"
                    name="address"
                    value={form.address}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div>
                  <FormInput
                    label="Date of Birth"
                    name="dob"
                    type="date"
                    value={form.dob}
                    onChange={handleChange}
                    className="form-input"
                  />
                </div>
                <div>
                  <label className="block mb-1 font-medium">Role</label>
                  <Select
                    options={roleOptions}
                    value={roleOptions.find(
                      (opt) => opt.value === (form.roleName ?? user.role?.role)
                    )}
                    onChange={handleRoleChange}
                    isClearable
                    placeholder="Select role"
                  />
                </div>
                <div className="md:col-span-2 flex items-center gap-4">
                  <label className="block font-medium mb-0">Status:</label>
                  <input
                    className="form-switch"
                    type="checkbox"
                    role="switch"
                    id="flexSwitchCheckActive"
                    checked={!!(form.active ?? user.active)}
                    onChange={() =>
                      setForm({
                        ...form,
                        active: !(form.active ?? user.active),
                      })
                    }
                  />
                  <label className="ms-1.5" htmlFor="flexSwitchCheckActive">
                    {form.active ?? user.active ? (
                      <span className="text-green-600 font-semibold">
                        Active {/* Người dùng đang hoạt động */}
                      </span>
                    ) : (
                      <span className="text-red-600 font-semibold">
                        Banned  
                        <span className="text-gray-500 font-base">
                          {"  This user is banned, because of some reason"}
                        </span>
                      </span>
                    )}
                  </label>
                </div>
              </div>

              <button
                type="submit"
                className="btn bg-primary text-white mt-6"
                disabled={saving}
              >
                {saving ? "Saving..." : "Update"}
              </button>
            </form>

            {/* Popup xác nhận */}
            {confirmOpen && (
              <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-40">
                <div className="bg-white rounded-lg shadow-lg p-6 w-full max-w-sm">
                  <h4 className="font-semibold mb-2">Confirm Update</h4>
                  <p className="mb-4 text-sm">
                    Please enter the username <span className="font-bold">{user?.username}</span> to confirm update.
                  </p>
                  <input
                    type="text"
                    className="form-input w-full mb-2"
                    placeholder="Enter username"
                    value={confirmName}
                    onChange={e => setConfirmName(e.target.value)}
                  />
                  {confirmError && (
                    <div className="text-red-600 text-sm mb-2">{confirmError}</div>
                  )}
                  <div className="flex justify-end gap-2">
                    <button
                      type="button"
                      className="btn bg-gray-200"
                      onClick={() => {
                        setConfirmOpen(false);
                        setConfirmName("");
                        setConfirmError("");
                      }}
                    >
                      Cancel
                    </button>
                    <button
                      type="button"
                      className="btn bg-primary text-white"
                      onClick={handleConfirmUpdate}
                    >
                      Confirm
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default EditUser;
