import { Tab } from "@headlessui/react";
import { PageBreadcrumb } from "../../components";
import React, { useEffect, useState } from "react";
import { fetchRolesAll, fetchPermissions, Role, Permission } from "./data";
import { APICore } from "../../helpers/api/apiCore";
import { toast } from "react-hot-toast";

const api = new APICore();

const updateRolePermissions = async (roleId: number, permissionIds: number[]) => {
  const payload = {
    roleId,
    permissionIds,
  };
  return api.update("/identity/role/update-role-permissions", payload);
};

const PermissionTable = ({
  allPermissions,
  checkedPermissions,
  onPermissionChange,
}: {
  allPermissions: Permission[];
  checkedPermissions: number[]; 
  onPermissionChange: (permId: number) => void;
}) => {
  return (
    <div className="card">
      <div className="card-header">
        <h4 className="card-title">Permissions</h4>
      </div>
      <div>
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead className="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th className="py-3 ps-4 w-16">#</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase w-72">
                  Permission
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase w-96">
                  Description
                </th>
                <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase w-24">
                  Has
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {allPermissions.map((perm, idx) => (
                <tr key={perm.id}>
                  <td className="py-3 ps-4">{idx + 1}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800 dark:text-gray-200">
                    {perm.permission}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-gray-200">
                    {perm.description}
                  </td>
                  <td className="px-6 py-4 text-center">
                    <input
                      type="checkbox"
                      checked={checkedPermissions.includes(perm.id)}
                      onChange={() => onPermissionChange(perm.id)}
                      className="form-checkbox h-5 w-5 text-primary"
                    />
                  </td>
                </tr>
              ))}
              {allPermissions.length === 0 && (
                <tr>
                  <td colSpan={4} className="text-center py-4 text-gray-400">
                    No permissions
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

const RolePermission = () => {
  const [roles, setRoles] = useState<Role[]>([]);
  const [allPermissions, setAllPermissions] = useState<Permission[]>([]);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [checkedPermissions, setCheckedPermissions] = useState<number[]>([]);

  useEffect(() => {
    fetchRolesAll().then(setRoles);
    fetchPermissions().then(setAllPermissions);
  }, []);

  useEffect(() => {
    if (roles[selectedIndex]) {
      setCheckedPermissions(roles[selectedIndex].permissions?.map((p) => p.id) || []);
    }
  }, [selectedIndex, roles]);

  const handlePermissionChange = (permId: number) => {
    setCheckedPermissions((prev) =>
      prev.includes(permId)
        ? prev.filter((id) => id !== permId)
        : [...prev, permId]
    );
  };

  const handleUpdate = async () => {
    const roleId = roles[selectedIndex]?.id;
    if (!roleId) return;
    toast.promise(
      updateRolePermissions(roleId, checkedPermissions)
        .then(() => fetchRolesAll().then(setRoles)),
      {
        loading: "Updating permissions...",
        success: "Permissions updated successfully!",
        error: "Failed to update permissions!",
      }
    );
  };

  return (
    <>
      <PageBreadcrumb
        title="Role-Permission"
        name="Role-Permission"
        breadCrumbItems={["Fitmate", "Manage User", "Role-Permission"]}
      />
      <div className="grid 2xl:grid-cols-1 grid-cols-1 gap-6">
        <div className="card">
          <div className="card-header">
            <div className="flex justify-between items-center">
              <h4 className="card-title">Role And Permission</h4>
            </div>
          </div>
          <div className="p-6">
            <div className="flex gap-3">
              <div className="grid md:grid-cols-8 gap-5">
                <Tab.Group
                  selectedIndex={selectedIndex}
                  onChange={setSelectedIndex}
                  vertical
                >
                  <Tab.List
                    as="nav"
                    className="flex md:flex-col col-span-2 gap-2 space-y-2"
                  >
                    {(roles || []).map((role, idx) => (
                      <Tab
                        key={role.id}
                        className={({ selected }) =>
                          `btn ${
                            selected
                              ? "bg-primary text-white"
                              : "bg-transparent"
                          }`
                        }
                      >
                        {role.role}
                      </Tab>
                    ))}
                  </Tab.List>
                  <Tab.Panels className="md:col-span-6">
                    {(roles || []).map((role, idx) => (
                      <Tab.Panel key={role.id}>
                        <div>
                          <h5 className="font-semibold mb-2">
                            {role.description}
                          </h5>
                          <PermissionTable
                            allPermissions={allPermissions}
                            checkedPermissions={checkedPermissions}
                            onPermissionChange={handlePermissionChange}
                          />
                        </div>
                      </Tab.Panel>
                    ))}
                    <div className="flex justify-end">
                      <button
                        type="button"
                        className="btn bg-primary text-white mt-6"
                        onClick={handleUpdate}
                      >
                        Update Permission
                      </button>
                    </div>
                  </Tab.Panels>
                </Tab.Group>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default RolePermission;
