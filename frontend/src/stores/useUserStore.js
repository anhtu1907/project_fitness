import { create } from "zustand";
import { persist } from "zustand/middleware";
const useUserStore = create(
  persist(
    (set, get) => ({
      user: null,
      isAuthenticated: false,
      hasRole: (role) => {
        const { user } = get();
        return user?.role === role;
      },
      setUser: (user) => set({ user: user, isAuthenticated: true }),
      logout: () => {
        localStorage.removeItem("authToken");
        set({ user: null, isAuthenticated: false });
      },
    }),
    {
      name: "user-store", // localStorage key
      getStorage: () => localStorage,
    }
  )
);

export default useUserStore;
/**
 *  isLogin ? =
 * user: {
 *  id:
 *  username:
 *  role: user | admin
 *  permissions = [
 *
 * ]
 *  }
 */
