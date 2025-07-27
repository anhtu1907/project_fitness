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

const EditUser = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [user, setUser] = useState<UserResponse | null>(null);
  const [form, setForm] = useState<UserUpdateRequest>({});
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [roleOptions, setRoleOptions] = useState<RoleOption[]>([]);

  // Load user info
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
          });
        })
        .catch(() => setError("User not found"))
        .finally(() => setLoading(false));
    }
  }, [id]);

  useEffect(() => {
    fetchRoles().then(setRoleOptions);
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleRoleChange = (selected: RoleOption | null) => {
    setForm({ ...form, roleName: selected ? selected.value : undefined });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!id) return;
    setSaving(true);
    setError(null);
    try {
      await updateUser(id, form);
      navigate("/manage-users/users");
    } catch (err: any) {
      setError("Update failed");
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
              </div>
              <button
                type="submit"
                className="btn bg-primary text-white mt-6"
                disabled={saving}
              >
                {saving ? "Saving..." : "Update"}
              </button>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default EditUser;