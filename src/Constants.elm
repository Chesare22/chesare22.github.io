module Constants exposing
    ( Book
    , BookCompletion(..)
    , ContactInfo
    , Highlight(..)
    , Job
    , Project
    , SimpleDate
    , books
    , contactList
    , email
    , jobs
    , name
    , projects
    )

import FeatherIcons
import Language exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Svg.Styled
import Time


name : String
name =
    "César González"


email : String
email =
    "ces.gonzalezortega@gmail.com"


type alias ContactInfo msg =
    { href : String
    , text : String
    , icon : Svg.Styled.Svg msg
    }


contactList : Int -> List (ContactInfo msg)
contactList iconSize =
    [ { href = "mailto:" ++ email
      , text = email
      , icon = Svg.Styled.fromUnstyled <| Filled.email iconSize Inherit
      }
    , { href = "https://github.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.github
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://www.linkedin.com/in/cgonzalez22/"
      , text = "/cgonzalez22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.linkedin
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    ]


type alias Job =
    { title : Language.Language -> String
    , start : SimpleDate
    , end : Maybe SimpleDate
    , position : Language.Language -> String
    , description : Language.Language -> String
    }


type alias SimpleDate =
    { month : Time.Month
    , year : Int
    }


jobs : List Job
jobs =
    [ Job (always "MID Software")
        (SimpleDate Time.Mar 2022)
        (Just <| SimpleDate Time.Aug 2023)
        (Language.translated "Desarrollador Web Full-Stack" "Full-Stack Web Developer")
        (Language.translated
            """
            Empresa enfocada en la creación de herramientas para facilitar tareas administrativas complejas.
            Mis principales actividades incluyeron programar una aplicación web hecha en React y Django,
            donde pude implementar varios patrones de diseño funcionales que facilitaron la modificación del código fuente.
            También lideré el desarrollo de una aplicación WPF, donde creé una librería para manejar fácilmente datos almacenados en CTEs recursivos.
            """
            """
            Enterprise focused on the development of tools to help complex administrative work.
            My main duties included programming a web application made with React and Django,
            where I could implement various functional design patterns that facilitated the modification of our source code.
            I also led the development of a WPF application, where I created a library to easily manage data stored in recursive CTEs.
            """
        )
    , Job (always "Coatí Labs")
        (SimpleDate Time.Jan 2021)
        (Just <| SimpleDate Time.Apr 2021)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            """
            En Coatí se desarrollan aplicaciones web a la medida, como sistemas de CRM y comercios electrónicos.
            Estuve involucrado en varios proyectos donde mis contribuciones incluían programar en React y participar en tomas de decisiones arquitectónicas.
            """
            """
            Coatí Labs develops custom web applications, like CRM systems and e-commerces.
            I was involved in several projects where my main contributions included programming in React and take part in architectural decision making.
            """
        )
    , Job (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2021)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            """
            Una startup formada por mí y un equipo de compañeros capaces.
            Nuestros principales proyectos fueron un exitoso blog de música y una pequeña aplicación para la administración de facturas.
            Mis tareas incluyeron la participación en reuniones con clientes dirigidas a entender requisitos y proponer soluciones, la programación en Vue y React,
            definir un estándar de programación y participar en la investigación y toma de decisiones sobre tecnologías a emplear.
            Fue donde más aprendí sobre ingeniería de software, trato con clientes y organización de proyectos.
            """
            """
            Startup formed by me and a team of capable schoolfellows.
            Our main projects were a successful music blog and a small application to manage invoices.
            My tasks included programming in Vue and React, taking part in meetings with clients aimed at understanding their requirements and proposing solutions,
            define a programming standard and participate in the research and decision-making around our tech stack.
            Here I learned the most about software engineering, project management and how to have agreements with clients.
            """
        )
    , Job (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            """
            Empresa dedicada al desarrollo de inteligencia artificial para la creación de chatbots.
            Mi principal labor fue la programación en Vue de una aplicación web que permitía personalizar y desplegar chatbots en distintas plataformas.
            A pesar de que ya había programado en entornos académicos, aquí aprendí a profundidad sobre el desarrollo web,
            la personalización de mi entorno de trabajo, el uso de git, pruebas y otras habilidades básicas como programador.
            """
            """
            Company dedicated to the development of artificial intelligence to create chatbots.
            My main labour was to program a Vue application to personalize and deploy chatbots in multiple platforms.
            Although I have programmed in academic environments, here I learned in depth about web development,
            the personalization of my work environment, git, testing and other basic programming skills.
            """
        )
    ]


type alias Project =
    { title : Language.Language -> String
    , url : String
    , year : Int
    , description : Language.Language -> String
    }


dummyDescription : Language.Language -> String
dummyDescription =
    Language.translated
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam iaculis turpis et libero fringilla auctor. Curabitur imperdiet semper pulvinar. Aenean turpis magna, consequat sed orci a, scelerisque gravida nisi. Proin venenatis convallis mi, et euismod odio bibendum cursus. Nulla fermentum neque vel odio interdum molestie. Morbi sed odio a lorem tempor blandit. Donec fringilla lacinia tortor, quis vulputate felis malesuada et. Nullam nunc nibh, aliquet eget ligula viverra, consequat aliquet orci. Donec et ornare lacus."
        "Cat ipsum dolor sit amet, dream about hunting birds eat half my food and ask for more. Kitty kitty chase dog then run away eat a plant, kill a hand walk on a keyboard and milk the cow leave hair everywhere. Shed everywhere shed everywhere stretching attack your ankles chase the red dot, hairball run catnip eat the grass sniff under the bed commence midnight zoomies for plays league of legends lick plastic bags. Have a lot of grump in yourself because you can't forget to be grumpy and not be like king grumpy cat relentlessly pursues moth chase laser curl up and sleep on the freshly laundered towels."


projects : List Project
projects =
    [ Project (always "MiObra Export App")
        "https://apps.microsoft.com/detail/XPFF9W7DQL962Z"
        2021
        dummyDescription
    , Project (always "MiObra")
        "https://www.miobra.mx/"
        2021
        dummyDescription
    , Project (Language.translated "Mi currículum vitae" "My resume")
        "https://chesare22.github.io/"
        2021
        dummyDescription
    , Project (always "Dark Impala")
        "https://darkimpala.com/"
        2020
        dummyDescription
    , Project (always "Comportia")
        "https://medium.com/soldai/comportia-una-idea-hecha-realidad-6bd77e542882"
        2019
        dummyDescription
    , Project (Language.translated "Programa de votos usando MVC" "Votes system using MVC")
        "https://github.com/Chesare22/Semestre-5/tree/arquitectura/Votes/src/main/java"
        2019
        dummyDescription
    , Project (Language.translated "Temporizador-PIC18F4550" "Timer-PIC18F4550")
        "https://github.com/Chesare22/Temporizador-PIC18F4550"
        2018
        dummyDescription
    ]


type alias Book =
    { title : String
    , author : String
    , completion : BookCompletion
    , highlight : Highlight
    }


type BookCompletion
    = Finished
    | Midway Int


type Highlight
    = Regular
    | Highlighted


books : List Book
books =
    [ Book "JavaScript: The Good Parts"
        "Douglas Crockford"
        Finished
        Highlighted
    , Book "You Don't Know JS (book series)"
        "Kyle Simpson"
        (Midway 85)
        Regular
    , Book "Domain Modeling Made Functional"
        "Scott Wlaschin"
        (Midway 50)
        Highlighted
    , Book "CSS Secrets"
        "Lea Verou"
        (Midway 25)
        Regular
    , Book "Programming Elixir"
        "Dave Thomas"
        (Midway 70)
        Highlighted
    , Book "Functional-Light JavaScript"
        "Kyle Simpson"
        Finished
        Regular
    , Book "Effective TypeScript"
        "Dan Vanderkam"
        (Midway 20)
        Regular
    , Book "MongoDB: The Definitive Guide"
        "Kristina Chodorow"
        (Midway 20)
        Regular
    , Book "Python Distilled"
        "David M. Beazley"
        (Midway 15)
        Regular
    ]
