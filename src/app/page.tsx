import Image from "next/image";

function About() {
  return (
    <section className="md:my-4">
      <h2>About Me</h2>
      <p>
        Hello there! I'm Alexander, a software developer from Ecuador, currently working as a
        consultant. I am passionate about distributed systems, open source, Linux and functional
        programming, among other things. Some of my non-programming hobbies include language learning,
        reading, photography and playing the bass. Feel free to contact me if you want to chat
        about anything: <a href="mailto:goussasalexander@gmail.com">goussasalexander@gmail.com</a>.
      </p>
    </section>
  )
}

function TechStack() {
  return (
    <section className="md:my-4">
      <h2>Tech Stack</h2>
      <p>This is the tech I normally use:</p>
      <ul className="list-disc list-inside">
        <li>Backend: GoLang or SpringBoot</li>
        <li>Mobile: Jetpack Compose or Flutter (I'm learning React Native for work)</li>
        <li>Web: React with Next.js</li>
      </ul>
      I also use a plethora of other programming languages, but I'm trying to master these things.
    </section>
  )
}

function Project({ name, description, url }: {
  name: string,
  description: string,
  url: string
}) {
  return (
    <li>
      <a href={url} target="_blank" className="underline">{name}</a> - {description}
    </li>
  )
}

function Projects() {
  const projects = [
    {
      name: 'Alexandria',
      description: 'Digital book library',
      url: 'https://github.com/Alexandria-Digital-Book-Library'
    },
    {
      name: 'Amigos con Cola',
      description: 'Admin portal for a non-profit animal shelter in Guayaquil',
      url: 'https://github.com/Amigos-Con-Cola'
    }
  ]

  return (
    <section className="md:my-4">
      <h2>Projects</h2>
      <p>These are some of the projects I'm currently working on that you might find interesting:</p>
      <ul className="list-disc list-inside">
        {projects.map(project => <Project {...project} key={project.name} />)}
      </ul>
    </section>
  )
}

export default function Home() {
  return (
    <div className="mx-auto md:max-w-[60%] md:mt-[5rem]">
      <h1>Alexander Goussas</h1>
      <About />
      <TechStack />
      <Projects />
    </div>
  );
}
