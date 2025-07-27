import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import MainLayout from "../layouts/MainLayout";
import HomeImage from "../assets/images/home-main.jpg";
import LinkCard from "../components/products/LinkCard";
import AnyWhereImage from "../assets/images/icon-access-anywhere.svg";
import SecurityImage from "../assets/images/icon-security.svg";
import CollaborationImage from "../assets/images/icon-collaboration.svg";
import AnyFileImage from "../assets/images/icon-any-file.svg";
import useExerciseStore from "../stores/useExerciseStore";
import ExerciseLinkCard from "../components/exercises/ExerciseLinkCard";
import { getProductTopCards } from "../services/productService";
import { useEffect, useState } from "react";

function HomePage() {
  // get best products, workouts from API
  const { bestExercises } = useExerciseStore();

  const [bestEquipments, setBestEquipments] = useState([]);
  const [bestSupplements, setBestSupplements] = useState([]);

  // Api
  const fetchTopCards = async () => {
    const result = await getProductTopCards(4);
    return result.data;
  };

  useEffect(() => {
    const loadData = async () => {
      try {
        const products = await fetchTopCards();
        const equipments = products.filter((p) => p.type === "equipment");
        const supplements = products.filter((p) => p.type === "supplement");
        setBestEquipments(equipments);
        setBestSupplements(supplements);
      } catch (error) {
        console.error("Can't not load data: ", error);
      }
    };
    loadData();
  }, []);

  return (
    <MainLayout>
      <section id="hero">
        {/* <!-- Container For Image & Content --> */}
        <div className="container flex flex-col-reverse mx-auto p-6 lg:flex-row lg:mb-0">
          {/* <!-- Content --> */}
          <div className="flex flex-col space-y-10 lg:mt-16 lg:w-1/2">
            <div className="text-2xl font-semibold text-center lg:text-6xl lg:text-left">
              A Simple Application for home workouts
            </div>
            <div className="max-w-md mx-auto text-sm text-center text-gray-400 lg:text-2xl lg:text-left lg:mt-0 lg:mx-0">
              <i>
                Fitmate is a user-friendly application designed to help you
                track your fitness journey, monitor your progress, and discover
                new fitness products that suit your needs. Whether you're a
                beginner or an experienced fitness enthusiast, Fitmate has
                something for everyone.
              </i>
            </div>

            {/* <!-- Buttons Container --> */}
            <div className="flex items-center justify-center w-full space-x-4 lg:justify-start">
              <a
                href="#"
                className="p-4 text-sm font-semibold text-white bg-sky-400 rounded shadow-md border-2 border-sky-200 md:text-base hover:bg-white hover:text-sky-200"
              >
                Get It On Google Play
                <FontAwesomeIcon
                  icon={["fab", "google-play"]}
                  className="ml-2"
                  spin
                />
              </a>
              <a
                href="/login"
                className="p-4 text-sm font-semibold text-black bg-gray-300 rounded shadow-md border-2 border-gray-300 md:text-base hover:bg-white hover:text-gray-600"
              >
                Login to Your Account
              </a>
            </div>
          </div>

          {/* <!-- Image --> */}
          <div className="relative mx-auto lg:mx-0 lg:mb-0 lg:w-1/2">
            <div className="bg-hero"></div>
            <img
              src={HomeImage}
              alt=""
              className="relative z-10 lg:top-24 xl:top-0 overflow-x-visible rounded-4xl shadow-lg"
            />
          </div>
        </div>
      </section>
      <div className="border-t-2 border-sky-600"></div>

      {/* Best Equipments Section */}
      <section id="equipments" className="py-10">
        <div className="text-center text-4xl font-extrabold text-sky-900 py-2 mb-4">
          Best Equipments All Time
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {bestEquipments && bestEquipments.length > 0 ? (
            bestEquipments.map((p, index) => (
             <LinkCard
                key={p.id || index}
                type={p.type}
                id={p.id}
                name={p.name}
                image={p.image}
                price={p.price}
                discount={p.discount}
                stock={p.stock}
                rating={p.rating}
                detailId={p.detailId}
              />
            ))
          ) : (
            <div className="col-span-full text-center py-8">
              <p className="text-gray-500">No products found</p>
            </div>
          )}
        </div>
      </section>
      <div className="border-t-2 border-sky-600"></div>
      {/* Best Supplements Section */}
      <section id="supplements" className="py-10">
        <div className="text-center text-4xl font-extrabold text-sky-900 py-2 mb-4">
          Best Supplement All Time
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {bestSupplements && bestSupplements.length > 0 ? (
            bestSupplements.map((p, index) => (
              <LinkCard
                key={p.id || index}
                type={p.type}
                id={p.id}
                name={p.name}
                image={p.image}
                price={p.price}
                discount={p.discount}
                stock={p.stock}
                rating={p.rating}
                detailId={p.detailId}
              />
            ))
          ) : (
            <div className="col-span-full text-center py-8">
              <p className="text-gray-500">No products found</p>
            </div>
          )}
        </div>
      </section>
      {/* Best Exercises Section */}
      <section id="exercises" className="py-10">
        <div className="text-center text-4xl font-extrabold text-orange-500 py-2 mb-4">
          Best Workouts for Beginners
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {bestExercises && bestExercises.length > 0 ? (
            bestExercises.map((e, index) => (
              <ExerciseLinkCard
                key={e.id || index}
                id={e.id}
                name={e.name}
                type={e.type}
                level={e.level}
                duration={e.duration}
                image={e.image}
              />
            ))
          ) : (
            <div className="col-span-full text-center py-8">
              <p className="text-gray-500">No workouts found</p>
            </div>
          )}
        </div>
      </section>
      <div className="border-t-2 border-sky-600"></div>

      {/* Features Section */}
      <section id="features" className="pt-12 bg-gray-50">
        {/* <!-- Features Container --> */}
        <div className="container mx-auto px-6 pb-32">
          {/* <!-- First Row --> */}
          <div className="flex flex-col space-y-24 text-center md:flex-row md:space-y-0">
            {/* <!-- Item 1 --> */}
            <div className="flex flex-col items-center space-y-2 md:w-1/2">
              <div className="flex items-center justify-center h-24 mb-6">
                <img src={AnyWhereImage} alt="" />
              </div>
              <h3 className="text-xl font-bold">Buy any product you want</h3>
              <p className="max-w-md">
                Fitmate offers a wide range of fitness products, from
                supplements to workout gear, all available for purchase within
                the app. You can easily browse and buy products that suit your
                fitness needs.
              </p>
            </div>
            {/* <!-- Item 2 --> */}
            <div className="flex flex-col items-center space-y-2 md:w-1/2">
              <div className="flex items-center justify-center h-24 mb-6">
                <img src={SecurityImage} alt="" />
              </div>
              <h3 className="text-xl font-bold">Security you can trust</h3>
              <p className="max-w-md">
                Fitmate prioritizes your security with features like 2-factor
                authentication and user-controlled encryption, ensuring that
                your personal information and fitness data are always protected.
              </p>
            </div>
          </div>

          {/* <!-- Second Row --> */}
          <div className="flex flex-col space-y-24 mt-28 text-center md:flex-row md:space-y-0">
            {/* <!-- Item 3 --> */}
            <div className="flex flex-col items-center space-y-2 md:w-1/2">
              <div className="flex items-center justify-center h-24 mb-6">
                <img src={CollaborationImage} alt="" />
              </div>
              <h3 className="text-xl font-bold">
                Tracking your progress easily with Fitmate
              </h3>
              <p className="max-w-md">
                Fitmate allows you to track your fitness progress effortlessly.
                You can log your workouts, monitor your nutrition, and set
                achievable goals to stay motivated on your fitness journey.
              </p>
            </div>
            {/* <!-- Item 4 --> */}
            <div className="flex flex-col items-center space-y-2 md:w-1/2">
              <div className="flex items-center justify-center h-24 mb-6">
                <img src={AnyFileImage} alt="" />
              </div>
              <h3 className="text-xl font-bold">Release and Support</h3>
              <p className="max-w-md">
                Fitmate provides regular updates and support to ensure that you
                have the best experience possible. You can access the latest
                features and improvements, and our support team is always ready
                to assist you with any questions or issues.
              </p>
            </div>
          </div>
        </div>
      </section>
      <div className="border-t-2 border-sky-600"></div>
      {/* Subscribe */}
      <section className="flex justify-between items-start">
        <div className="max-w-lg mx-auto py-12">
          <h2 className="px-3 mb-6 text-3xl font-semibold text-center text-gray-800 md:text-4xl">
            Stay up-to-date with what we're doing
          </h2>
          <form className="flex flex-col items-start justify-center max-w-2xl mx-auto mt-3 space-y-6 text-base px-6 md:flex-row md:space-y-0 md:space-x-4 md:px-0">
            <div className="flex flex-col justify-between items-center mx-auto md:flex-row md:mx-0">
              <input
                type="text"
                className="flex-1 px-6 pt-3 pb-2 mb-4 rounded-lg border-1 border-gray-800 focus:outline-none md:mr-3 md:mb-0"
                placeholder="Enter your email address"
              />

              <input
                type="submit"
                className="inline-flex px-6 py-3 font-semibold text-center text-white duration-200 transform rounded-lg cursor-pointer focus:outline-none bg-orange-500 hover:opacity-90"
                value="Contact Us"
              />
            </div>
          </form>
        </div>
      </section>
    </MainLayout>
  );
}

export default HomePage;
