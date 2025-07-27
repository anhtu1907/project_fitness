import MainLayout from "../layouts/MainLayout";
import { motion } from "framer-motion";

function AboutPage() {
  const sections = [
    {
      title: "🎯 Our Mission",
      content: `FitMate was created to help individuals build and maintain healthy workout habits paired with scientifically backed nutritional plans. Our mission is to make health and fitness more approachable and personalized for everyone, regardless of experience level.

We believe that achieving your dream body and better health is not about extremes, but about consistency, structure, and proper guidance. Through a combination of daily workouts, tailored nutrition, and progress tracking, FitMate empowers users to take control of their journey toward a better self — physically and mentally.

Our team is committed to delivering tools that support long-term behavior change, ensuring users not only reach their goals but sustain them. FitMate isn't just an app — it's a companion in your transformation.`,
    },
    {
      title: "📱 Purpose of Use",
      content: `FitMate is designed for users of all fitness levels to achieve specific, personal health goals. The app enables you to create customized fitness routines, plan your meals according to your body needs, and monitor your results over time through simple yet powerful tracking tools.

Whether you're aiming to lose weight, build muscle, improve endurance, or simply maintain a healthier lifestyle, FitMate offers smart recommendations to match your lifestyle and preferences. You can set workout reminders, create daily routines, and even follow suggested plans created by certified fitness experts.

Our purpose is to provide a seamless and enjoyable experience that encourages consistent action — because small daily habits lead to lasting change. No complicated diets, no overwhelming workouts — just what works for you.`,
    },
    {
      title: "🚀 Future Vision",
      content: `We envision FitMate as a complete, intelligent digital platform for personal health and wellness. Our long-term vision includes integrating AI-powered coaching systems that provide real-time feedback, smart suggestions based on your progress, and adaptive plans that evolve as you do.

We are also working toward building a supportive online fitness community where users can share progress, tips, and motivation. Users will be able to engage in group challenges, access virtual trainers, and participate in live Q&A sessions with experts.

Ultimately, our goal is to democratize fitness: to make premium-level training and health guidance accessible and affordable to everyone — no matter their background, schedule, or location. FitMate will grow with you, every step of the way.`,
    },
  ];

  return (
    <MainLayout>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 text-gray-900">
        {sections.map((item, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 40 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.2 }}
            viewport={{ once: true }}
            className="p-8 rounded-xl bg-white border border-gray-900 shadow-sm hover:shadow-lg hover:border-purple-500 transition-all duration-300"
          >
            <h3 className="text-xl font-semibold mb-4">{item.title}</h3>
            <p className="leading-relaxed mt-2 whitespace-pre-line">{item.content}</p>
          </motion.div>
        ))}
      </div>
    </MainLayout>
  );
}

export default AboutPage;