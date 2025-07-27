import { APICore, getLoggedInUser } from "../../helpers/api/apiCore";
import config from "../../config";

const api = new APICore();

export interface Permission {
  id: number;
  permission: string;
  description?: string;
}

export interface Role {
  id: number;
  role: string;
  description?: string;
  permissions?: Permission[];
}

export interface UserResponse {
  id: string;
  username: string;
  firstName?: string | null;
  lastName?: string | null;
  email: string;
  phone?: string | null;
  address?: string | null;
  dob?: string | number[] | null;
  role: Role;
  active?: boolean;
}

export interface UserUpdateRequest {
  firstName?: string;
  lastName?: string;
  email?: string;
  phone?: string;
  address?: string;
  dob?: string;
  roleName?: string; // đổi từ roleId sang roleName
  active?: boolean; // Thêm trường active
}

export interface UserStatistic {
  count: number;
  icon: string;
  variant: string;
  status: string;
}

export interface PagedUserResponse {
  content: UserResponse[];
  totalElements: number;
  totalPages: number;
  number: number;
  size: number;
}

export interface RoleOption {
  value: string; // roleName là string
  label: string;
}

// Lấy user theo id
export async function fetchUserById(userId: string): Promise<UserResponse> {
  const res = await api.get(`/identity/user/id/${userId}`);
  return res.data.data;
}

// Lấy danh sách user có phân trang
export async function fetchUsers(page = 1, size = 10): Promise<PagedUserResponse> {
  const res = await api.get(`/identity/user`, {
    params: { page: page - 1, size },
  });
  return res.data.data;
}

// Lấy user theo username
export async function fetchUserByUsername(username: string): Promise<UserResponse> {
  const res = await api.get(`/identity/user/username/${username}`);
  return res.data.data;
}

// Update user
export async function updateUser(userId: string, data: UserUpdateRequest) {
  console.log("fetchUserById", data);
  const res = await api.update(`/identity/user/${userId}`, data);
  
  return res.data.data;
}

// Lấy danh sách role cho select
export async function fetchRoles(): Promise<RoleOption[]> {
  const res = await api.get(`/identity/role`);
  return (res.data.data || []).map((role: any) => ({
    value: role.role, // roleName là string
    label: role.role,
  }));
}

const updateRolePermissions = async (roleId: number, permissionIds: number[]) => {
  const payload = {
    roleId,
    permissionIds,
  };
  return api.update("/identity/role/update-role-permissions", payload);
};

// Lấy tất cả role (kèm permission)
export async function fetchRolesAll(): Promise<Role[]> {
  const res = await api.get(`/identity/role`);
  return res.data.data;
}

// Lấy tất cả permission
export async function fetchPermissions(): Promise<Permission[]> {
  const res = await api.get(`/identity/permission`);
  return res.data.data;
}


export async function fetchUsersByKeyword(keyword: string, page = 1, size = 4): Promise<PagedUserResponse> {
  const res = await api.get(`/identity/user/search`, {
    params: { keyword, page: page - 1, size },
  });
  return res.data.data;
}

export interface UserStatisticsResponse {
  totalUsers: number;
  activeUsers: number;
  inactiveUsers: number;
  weeklyActiveUsers: number;
}

export async function fetchUserStatistics(): Promise<UserStatisticsResponse> {
  const res = await api.get(`/identity/user/statistics`);
  return res.data.data;
}

export async function fetchInactiveUsers(page = 1, size = 10): Promise<PagedUserResponse> {
  const res = await api.get(`/identity/user/inactive`, {
    params: { page: page - 1, size },
  });
  return res.data.data;
}

export const userStatistics: UserStatistic[] = [
  {
    count: 3947,
    icon: "mgc_tag_line",
    status: "Total",
    variant: "bg-primary/25 text-primary",
  },
  {
    count: 624,
    icon: "mgc_alarm_2_line",
    status: "Pending",
    variant: "bg-yellow-100 text-yellow-500",
  },
  {
    count: 3195,
    icon: "mgc_check_line",
    status: "Closed",
    variant: "bg-green-100 text-green-500",
  },
  {
    count: 128,
    icon: "mgc_delete_line",
    status: "Deleted",
    variant: "bg-red-100 text-red-500",
  },
];