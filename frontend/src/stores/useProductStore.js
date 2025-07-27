import {create} from "zustand";

import ProductData from "../data/products.json";

const useProductStore = create((set) => ({
  products: ProductData,
}));

export default useProductStore;