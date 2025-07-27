/* eslint-disable react-refresh/only-export-components */
import React from "react";
import { Navigate, Route, RouteProps } from "react-router-dom";

// components
import PrivateRoute from "./PrivateRoute";
import TicketsApp from "../pages/apps/Tickets";
import UsersApp from "../pages/users";
import ExerciseSubCategorys from "../pages/exercises/ExerciseSubCategorys";

// user pages
const UserDetail = React.lazy(() => import("../pages/users/UserDetail"));
const EditUSer = React.lazy(() => import("../pages/users/EditUser"));
const InactiveUsers = React.lazy(() => import("../pages/users/InActiveUser"));
const RolePermission = React.lazy(
  () => import("../pages/users/RolePermission")
);
// lazy load all the views

// products
const Products = React.lazy(() => import("../pages/products/Products"));
const AddEditProduct = React.lazy(
  () => import("../pages/products/AddEditProduct")
);
const Equipment = React.lazy(() => import("../pages/products/Equipments"));
const AddEditEquipment = React.lazy(
  () => import("../pages/products/AddEditEquipment")
);
const Promotion = React.lazy(() => import("../pages/products/Promotions"));
const AddEditPromotion = React.lazy(
  () => import("../pages/products/AddEditPromotion")
);
const Supplier = React.lazy(() => import("../pages/products/Suppliers"));
const AddEditSupplier = React.lazy(
  () => import("../pages/products/AddEditSupplier")
);
const Supplement = React.lazy(() => import("../pages/products/Supplements"));
const AddEditSupplement = React.lazy(
  () => import("../pages/products/AddEditSupplement")
);
const SCategory = React.lazy(() => import("../pages/products/SCategory"));
const AddEditSCategory = React.lazy(
  () => import("../pages/products/AddEditSCategory")
);
const ECategory = React.lazy(() => import("../pages/products/ECategory"));
const AddEditECategory = React.lazy(
  () => import("../pages/products/AddEditECategory")
);

// meals
const Meals = React.lazy(() => import("../pages/meals/Meals"));
const AddEditMeal = React.lazy(() => import("../pages/meals/AddEditMeal"));
const MealTimes = React.lazy(() => import("../pages/meals/MealTimes"));
const AddEditMealTime = React.lazy(
  () => import("../pages/meals/AddEditMealTime")
);
const AddEditMealCategory = React.lazy(
  () => import("../pages/meals/AddEditMealCategory")
);
const MealCategories = React.lazy(() => import("../pages/meals/MealCategorys"));
const AddEditMealSubCategory = React.lazy(
  () => import("../pages/meals/AddEditMealSubCategory")
);
const MealSubCategorys = React.lazy(
  () => import("../pages/meals/MealSubCategorys")
);

// exercises
const Exercises = React.lazy(() => import("../pages/exercises/Exercises"));
const AddEditExercise = React.lazy(
  () => import("../pages/exercises/AddEditExercise")
);
const AddEditEquipmentEx = React.lazy(
  () => import("../pages/exercises/AddEditEquipment")
);
const EquipmentEx = React.lazy(() => import("../pages/exercises/Equipments"));
const ExerciseModes = React.lazy(
  () => import("../pages/exercises/ExerciseModes")
);
const AddEditExerciseMode = React.lazy(
  () => import("../pages/exercises/AddEditExerciseMode")
);
const SubExerciseCategorys = React.lazy(
  () => import("../pages/exercises/ExerciseSubCategorys")
);
const AddEditExerciseSubCategory = React.lazy(
  () => import("../pages/exercises/AddEditExerciseSubCategory")
);
const ExerciseCategorys = React.lazy(
  () => import("../pages/exercises/ExerciseCategorys")
);
const AddEditExerciseCategory = React.lazy(
  () => import("../pages/exercises/AddEditExerciseCategory")
);
const AddEditExerciseProgram = React.lazy(
  () => import("../pages/exercises/AddEditExerciseProgram")
);
const ExercisePrograms = React.lazy(
  () => import("../pages/exercises/ExercisePrograms")
);

// Orders
const Orders = React.lazy(() => import("../pages/orders/Orders"));
const OrderDetail = React.lazy(() => import("../pages/orders/OrderDetail"));

// finance
const Finance = React.lazy(() => import("../pages/finance/Finance"));
// auth
const Login = React.lazy(() => import("../pages/auth/Login"));
const Register = React.lazy(() => import("../pages/auth/Register"));
const RecoverPassword = React.lazy(
  () => import("../pages/auth/RecoverPassword")
);
const LockScreen = React.lazy(() => import("../pages/auth/LockScreen"));

// dashboard
const Dashboard = React.lazy(() => import("../pages/dashboard/"));

// apps
const FileManagerApp = React.lazy(() => import("../pages/apps/FileManager"));

// extra pages
const Starter = React.lazy(() => import("../pages/extra/Starter"));
const Timeline = React.lazy(() => import("../pages/extra/TimeLine"));
const Invoice = React.lazy(() => import("../pages/extra/Invoice"));
const Gallery = React.lazy(() => import("../pages/extra/Gallery"));
const FAQs = React.lazy(() => import("../pages/extra/FAQs"));
const Pricing = React.lazy(() => import("../pages/extra/Pricing"));

// error pages
const Maintenance = React.lazy(() => import("../pages/error/Maintenance"));
const ComingSoon = React.lazy(() => import("../pages/error/ComingSoon"));
const Error404 = React.lazy(() => import("../pages/error/Error404"));
const Error404Alt = React.lazy(() => import("../pages/error/Error404Alt"));
const Error500 = React.lazy(() => import("../pages/error/Error500"));

export interface RoutesProps {
  path: RouteProps["path"];
  name?: string;
  element?: RouteProps["element"];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  route?: any;
  exact?: boolean;
  icon?: string;
  header?: string;
  roles?: string[];
  children?: RoutesProps[];
}

// dashboards
const dashboardRoutes: RoutesProps = {
  path: "/admin/home",
  name: "Dashboards",
  icon: "home",
  header: "Navigation",
  children: [
    {
      path: "/dashboard",
      name: "Root",
      element: <Navigate to="/dashboard" />,
      route: PrivateRoute,
    },
    {
      path: "/admin/dashboard",
      name: "Dashboard",
      element: <Dashboard />,
      route: PrivateRoute,
    },
  ],
};
// finance
const financeRoutes: RoutesProps = {
  path: "/admin/finance",
  name: "Finance",
  icon: "cart",
  header: "Navigation",
  element: <Finance />,
  children: [
    // {
    //   path: "/admin/finance/overview",
    //   name: "Finance",
    //   element: <Finance />,
    //   route: PrivateRoute,
    // },
    // {
    //   path: "/admin/order/detail/:id",
    //   name: "OrderDetail",
    //   element: <OrderDetail />,
    //   route: PrivateRoute,
    // },
    // {
    //   path: "/admin/manage-users/edit/:id",
    //   name: "ProjectCreate",
    //   element: <EditUSer />,
    //   route: PrivateRoute,
    // },
  ],
};

//Orders

const orderRoutes: RoutesProps = {
  path: "/admin/order",
  name: "Orders",
  icon: "cart",
  header: "Navigation",
  children: [
    {
      path: "/admin/order/orders",
      name: "ManageOrders",
      element: <Orders />,
      route: PrivateRoute,
    },
    {
      path: "/admin/order/detail/:id",
      name: "OrderDetail",
      element: <OrderDetail />,
      route: PrivateRoute,
    },
    // {
    //   path: "/admin/manage-users/edit/:id",
    //   name: "ProjectCreate",
    //   element: <EditUSer />,
    //   route: PrivateRoute,
    // },
  ],
};

const ticketsAppRoutes: RoutesProps = {
  path: "/admin/apps/tickets",
  name: "Tickets",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "tickets",
  element: <TicketsApp />,
  header: "Apps",
};

const usersRoutes: RoutesProps = {
  path: "/admin/manage-users",
  name: "Users",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "users",
  children: [
    {
      path: "/admin/manage-users/users",
      name: "ManageUsers",
      element: <UsersApp />,
      route: PrivateRoute,
    },
    {
      path: "/admin/manage-users/detail/:id",
      name: "ProjectDetail",
      element: <UserDetail />,
      route: PrivateRoute,
    },
    {
      path: "/admin/manage-users/edit/:id",
      name: "ProjectCreate",
      element: <EditUSer />,
      route: PrivateRoute,
    },
    {
      path: "/admin/manage-users/inactive",
      name: "InactiveUsers",
      element: <InactiveUsers />,
      route: PrivateRoute,
    },
    {
      path: "/admin/manage-users/role-permission",
      name: "RolePermission",
      element: <RolePermission />,
      route: PrivateRoute,
    },
  ],
};

// product routes
const productRoutes: RoutesProps = {
  path: "/admin/product",
  name: "Products",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "classify",
  children: [
    {
      path: "/admin/product/products",
      name: "ManageProducts",
      element: <Products />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/add",
      name: "AddProduct",
      element: <AddEditProduct />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/edit/:id",
      name: "EditProduct",
      element: <AddEditProduct />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/suppliers",
      name: "Supplier",
      element: <Supplier />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/supplier/edit/:id",
      name: "EditSupplier",
      element: <AddEditSupplier />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/supplier/add",
      name: "AddSupplier",
      element: <AddEditSupplier />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/supplements",
      name: "Supplement",
      element: <Supplement />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/supplement/edit/:id",
      name: "EditSupplier",
      element: <AddEditSupplier />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/supplement/add",
      name: "AddSupplement",
      element: <AddEditSupplement />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/promotions",
      name: "Promotion",
      element: <Promotion />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/promotion/edit/:id",
      name: "EditPromotion",
      element: <AddEditPromotion />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/promotion/add",
      name: "AddPromotion",
      element: <AddEditPromotion />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/equipments",
      name: "Equipment",
      element: <Equipment />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/equipment/edit/:id",
      name: "EditEquipment",
      element: <AddEditEquipment />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/equipment/add",
      name: "AddEquipment",
      element: <AddEditEquipment />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/scategory",
      name: "SCategory",
      element: <SCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/scategory/edit/:id",
      name: "EditEquipment",
      element: <AddEditSCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/scategory/add",
      name: "AddEquipment",
      element: <AddEditSCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/ecategory",
      name: "ECategory",
      element: <ECategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/ecategory/edit/:id",
      name: "EditEquipment",
      element: <AddEditECategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/product/ecategory/add",
      name: "AddEquipment",
      element: <AddEditECategory />,
      route: PrivateRoute,
    },
  ],
};

// meal routes
const mealsRoutes: RoutesProps = {
  path: "/admin/meal",
  name: "Meals",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "classify",
  children: [
    {
      path: "/admin/meal/meals",
      name: "ManageMeals",
      element: <Meals />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/add",
      name: "AddMeal",
      element: <AddEditMeal />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/edit/:id",
      name: "EditMeal",
      element: <AddEditMeal />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-times",
      name: "MealTimes",
      element: <MealTimes />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-time/add",
      name: "AddMeal",
      element: <AddEditMealTime />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-time/edit/:id",
      name: "EditMealTime",
      element: <AddEditMealTime />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-categories",
      name: "MealCategories",
      element: <MealCategories />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-category/add",
      name: "AddMealCategory",
      element: <AddEditMealCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-category/edit/:id",
      name: "EditMealCategory",
      element: <AddEditMealCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-subcategories",
      name: "MealSubCategorys",
      element: <MealSubCategorys />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-subcategory/add",
      name: "AddMealSubCategory",
      element: <AddEditMealSubCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/meal/meal-subcategory/edit/:id",
      name: "EditMealSubCategory",
      element: <AddEditMealSubCategory />,
      route: PrivateRoute,
    },
  ],
};

// meal routes
const exercisesRoutes: RoutesProps = {
  path: "/admin/exercise",
  name: "Exercises",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "classify",
  children: [
    {
      path: "/admin/exercise/exercises",
      name: "ManageExercises",
      element: <Exercises />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise/add",
      name: "AddExercise",
      element: <AddEditExercise />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise/edit/:id",
      name: "EditExercise",
      element: <AddEditExercise />,
      route: PrivateRoute,
    },

    {
      path: "/admin/exercise/equipments",
      name: "ManageEquipmentEx",
      element: <EquipmentEx />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/equipment/add",
      name: "AddExercise",
      element: <AddEditEquipmentEx />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/equipment/edit/:id",
      name: "EditExercise",
      element: <AddEditEquipmentEx />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-modes",
      name: "ExerciseModes",
      element: <ExerciseModes />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-mode/add",
      name: "AddExerciseMode",
      element: <AddEditExerciseMode />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-mode/edit/:id",
      name: "EditExerciseMode",
      element: <AddEditExerciseMode />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-sub-categories",
      name: "ExerciseSubCategorys",
      element: <SubExerciseCategorys />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-sub-category/add",
      name: "AddExerciseSubCategory",
      element: <AddEditExerciseSubCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-sub-category/edit/:id",
      name: "EditExerciseSubCategory",
      element: <AddEditExerciseSubCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-categories",
      name: "ExerciseCategorys",
      element: <ExerciseCategorys />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-category/add",
      name: "AddExerciseCategory",
      element: <AddEditExerciseCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-category/edit/:id",
      name: "EditExerciseSubCategory",
      element: <AddEditExerciseCategory />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-programs",
      name: "ExercisePrograms",
      element: <ExercisePrograms />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-program/add",
      name: "AddExerciseProgram",
      element: <AddEditExerciseProgram />,
      route: PrivateRoute,
    },
    {
      path: "/admin/exercise/exercise-program/edit/:id",
      name: "EditExerciseProgram",
      element: <AddEditExerciseProgram />,
      route: PrivateRoute,
    },
  ],
};

const fileAppRoutes: RoutesProps = {
  path: "/admin/apps/file-manager",
  name: "File Manager",
  route: PrivateRoute,
  roles: ["Admin"],
  icon: "filemanager",
  element: <FileManagerApp />,
  header: "Apps",
};

const appRoutes = [
  ticketsAppRoutes,
  usersRoutes,
  fileAppRoutes,
  productRoutes,
  mealsRoutes,
  exercisesRoutes,
  orderRoutes,
  financeRoutes
];

// pages
const customPagesRoutes = {
  path: "/pages",
  name: "Pages",
  icon: "pages",
  header: "Custom",
  children: [
    {
      path: "/pages/starter",
      name: "Starter",
      element: <Starter />,
      route: PrivateRoute,
    },
    {
      path: "/pages/timeline",
      name: "Timeline",
      element: <Timeline />,
      route: PrivateRoute,
    },
    {
      path: "/pages/invoice",
      name: "Invoice",
      element: <Invoice />,
      route: PrivateRoute,
    },
    {
      path: "/pages/gallery",
      name: "Gallery",
      element: <Gallery />,
      route: PrivateRoute,
    },
    {
      path: "/pages/faqs",
      name: "FAQs",
      element: <FAQs />,
      route: PrivateRoute,
    },
    {
      path: "/pages/pricing",
      name: "Pricing",
      element: <Pricing />,
      route: PrivateRoute,
    },
    {
      path: "/error-404-alt",
      name: "Error - 404-alt",
      element: <Error404Alt />,
      route: PrivateRoute,
    },
  ],
};

// auth
const authRoutes: RoutesProps[] = [
  {
    path: "/admin/auth/login",
    name: "Login",
    element: <Login />,
    route: Route,
  },
  {
    path: "/admin/auth/register",
    name: "Register",
    element: <Register />,
    route: Route,
  },
  {
    path: "/admin/auth/recover-password",
    name: "Recover Password",
    element: <RecoverPassword />,
    route: Route,
  },
];

// public routes
const otherPublicRoutes = [
  {
    path: "*",
    name: "Error - 404",
    element: <Error404 />,
    route: Route,
  },
  {
    path: "/maintenance",
    name: "Maintenance",
    element: <Maintenance />,
    route: Route,
  },
  {
    path: "/admin/coming-soon",
    name: "Coming Soon",
    element: <ComingSoon />,
    route: Route,
  },
  {
    path: "/admin/error-404",
    name: "Error - 404",
    element: <Error404 />,
    route: Route,
  },
  {
    path: "/admin/error-500",
    name: "Error - 500",
    element: <Error500 />,
    route: Route,
  },
];

// flatten the list of all nested routes
const flattenRoutes = (routes: RoutesProps[]) => {
  let flatRoutes: RoutesProps[] = [];

  routes = routes || [];
  routes.forEach((item: RoutesProps) => {
    flatRoutes.push(item);
    if (typeof item.children !== "undefined") {
      flatRoutes = [...flatRoutes, ...flattenRoutes(item.children)];
    }
  });
  return flatRoutes;
};

// All routes
const authProtectedRoutes = [dashboardRoutes, ...appRoutes, customPagesRoutes];
const publicRoutes = [...authRoutes, ...otherPublicRoutes];

const authProtectedFlattenRoutes = flattenRoutes([...authProtectedRoutes]);
const publicProtectedFlattenRoutes = flattenRoutes([...publicRoutes]);
export {
  publicRoutes,
  authProtectedRoutes,
  authProtectedFlattenRoutes,
  publicProtectedFlattenRoutes,
};
