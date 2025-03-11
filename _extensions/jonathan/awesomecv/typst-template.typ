#import "@preview/fontawesome:0.1.0": *

//------------------------------------------------------------------------------
// Style
//------------------------------------------------------------------------------

// const color
#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-middledarkgray = rgb("#414141")
#let color-gray = rgb("#5d5d5d")
#let color-lightgray = rgb("#999999")

// Default style
#let color-accent-default = rgb("#1a365d") // Dark blue instead of red
#let font-header-default = ("Montserrat", "Arial", "Helvetica", "Dejavu Sans") // Bold sans serif
#let font-text-default = ("Lato", "Arial", "Helvetica", "Dejavu Sans") // Lato as requested
#let align-header-default = center

// User defined style
$if(style.color-accent)$
#let color-accent = rgb("$style.color-accent$")
$else$
#let color-accent = color-accent-default
$endif$
$if(style.font-header)$
#let font-header = "$style.font-header$"
$else$
#let font-header = font-header-default
$endif$
$if(style.font-text)$
#let font-text = "$style.font-text$"
$else$
#let font-text = font-text-default
$endif$

//------------------------------------------------------------------------------
// Helper functions
//------------------------------------------------------------------------------

// icon string parser

#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") [
    #let parts = icon_string.split(" ")
    #if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-darknight)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), fa-set: "Brands", fill: color-darknight)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  ] else if icon_string.ends-with(".svg") [
    #box(image(icon_string))
  ] else {
    assert(false, "Invalid icon string")
  }
}

// context text parser
#let unescape_text(text) = {
  // This is not a perfect solution
  text.replace("\\", "").replace(".~", ". ")
}

// Simple italic text handling - just return as is to avoid errors
#let parse_italics(text) = {
  return text
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block(spacing: 0.4em)[
    #box(width: 3.5fr)[#left_body]
    #box(width: 1.5fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(
    size: 10pt,
    weight: "bold",
    style: "normal",
    fill: color-darkgray, // Changed to dark gray for dates
  )
  body
}

/// Right section of a tertiaty headers. 
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(
    weight: "regular",
    size: 9pt,
    style: "italic",
    fill: color-accent, // Changed to match the secondary header
  )
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(
    above: 0.7em, // Increased spacing
    below: 0.2em,
  )
  __justify_align[
    #set text(
      size: 11pt,
      weight: "bold",
      fill: color-darkgray,
    )
    #primary
  ][
    #secondary-right-header[#secondary]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 10pt, // Increased for better readability
      weight: "regular",
      style: "italic",
      fill: color-darkgray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}

//------------------------------------------------------------------------------
// Header
//------------------------------------------------------------------------------

#let create-header-name(
  firstname: "",
  lastname: "",
) = {
  
  pad(bottom: 3pt)[
    #block[
      #set text(
        size: 28pt, // Better sized header
        style: "normal",
        font: (font-header),
      )
      #text(fill: color-gray, weight: "thin")[#firstname]
      #text(weight: "bold")[#lastname]
    ]
  ]
}

#let create-header-position(
  position: "",
) = {
  set block(
      above: 0.4em,
      below: 0.4em,
    )
  
  set text(
    color-accent, // Dark blue as per request
    size: 9pt,
    weight: "regular",
  )
    
  smallcaps[
    #position
  ]
}

#let create-header-address(
  address: ""
) = {
  set block(
      above: 0.3em,
      below: 0.3em,
  )
  set text(
    color-lightgray,
    size: 8pt,
    style: "italic",
  )

  block[#address]
}

#let create-header-contacts(
  contacts: (),
) = {
  let separator = box(width: 2pt)
  if(contacts.len() > 1) {
    block[
      #set text(
        size: 8pt,
        weight: "regular",
        style: "normal",
      )
      #align(horizon)[
        #for contact in contacts [
          #set box(height: 8pt)
          #box[#parse_icon_string(contact.icon) #link(contact.url)[#contact.text]]
          #separator
        ]
      ]
    ]
  }
}

#let create-header-info(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  align-header: center
) = {
  align(align-header)[
    #create-header-name(firstname: firstname, lastname: lastname)
    #create-header-position(position: position)
    #create-header-address(address: address)
    #create-header-contacts(contacts: contacts)
  ]
}

#let create-header-image(
  profile-photo: ""
) = {
  if profile-photo.len() > 0 {
    block(
      above: 10pt,
      stroke: none,
      radius: 9999pt,
      clip: true,
      image(
        fit: "contain",
        profile-photo
      )
    ) 
  }
}

#let create-header(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  profile-photo: "",
) = {
  if profile-photo.len() > 0 {
    block[
      #box(width: 5fr)[
        #create-header-info(
          firstname: firstname,
          lastname: lastname,
          position: position,
          address: address,
          contacts: contacts,
          align-header: left
        )
      ]
      #box(width: 1fr)[
        #create-header-image(profile-photo: profile-photo)
      ]
    ]
  } else {
    
    create-header-info(
      firstname: firstname,
      lastname: lastname,
      position: position,
      address: address,
      contacts: contacts,
      align-header: center
    )

  }
}

//------------------------------------------------------------------------------
// Resume Entries
//------------------------------------------------------------------------------

#let resume-item(body) = {
  set text(
    size: 10pt, // Larger size to match description
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.65em) // Better line spacing
  set list(indent: 0.8em, spacing: 0.4em) // Better list spacing
  body
}

// Create a special clickable company name with visual indicator
#let company_with_link(name, url) = {
  if url != "" {
    link(url)[
      #set text(
        fill: color-darkgray,
        weight: "bold",
      )
      #box[
        #name #h(2pt) #text(size: 7pt, fill: color-accent)[↗]
      ]
    ]
  } else {
    set text(
      weight: "bold",
    )
    name
  }
}

// Modified with company_name as bold and title as italic underneath
#let resume-entry(
  title: none,
  date: "",
  description: "",
  company_name: "",
  company_url: "",
) = {
  block(spacing: 0.1em)[
    // Company name bold at the top left, date bold at top right
    #justified-header(
      company_with_link(parse_italics(company_name), company_url),
      date
    )
    
    // Job title in italics underneath company name
    #block(below: 0.6em)[
      #set text(
        size: 10pt,
        style: "italic",
        weight: "regular",
        fill: color-darkgray,
      )
      #title
    ]
    
    // Description with consistent text styling
    #if description != "" [
      #block(above: 0.2em, below: 0.2em)[
        #set text(
          size: 10pt,
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #parse_italics(description)
      ]
    ]
  ]
}

// Modified bullets function with company name bold at top and job title underneath in italics
#let resume-entry-bullets(
  title: none,
  date: "",
  description: "",
  bullets: (),
  company_name: "",
  company_url: "",
) = {
  block(spacing: 0.1em)[
    // Company name bold at the top left, date bold at top right
    #justified-header(
      company_with_link(parse_italics(company_name), company_url),
      date
    )
    
    // Job title in italics underneath company name
    #block(below: 0.3em)[
      #set text(
        size: 10pt,
        style: "italic",
        weight: "regular",
        fill: color-darkgray,
      )
      #title
    ]
    
    // Description with consistent text styling
    #if description != "" [
      #block(above: 0.2em, below: 0.2em)[
        #set text(
          size: 10pt,
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #parse_italics(description)
      ]
    ]
    
    #if bullets.len() > 0 [
      #block(above: 0.3em)[
        #set text(
          size: 10pt,
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #set par(leading: 0.65em) // Slightly increased leading for bullet points
        #list(
          ..bullets.map(item => [#parse_italics(item)]),
          indent: 0.8em,
          spacing: 0.4em // Increased bullet point spacing
        )
      ]
    ]
  ]
}

//------------------------------------------------------------------------------
// Resume Template
//------------------------------------------------------------------------------

#let resume(
  title: "CV",
  author: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  profile-photo: "",
  body,
) = {
  
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  
  set text(
    font: (font-text),
    size: 10pt, // Better base font size
    fill: color-darkgray,
    fallback: true,
  )
  
  set page(
    paper: "a4",
    margin: (left: 18mm, right: 18mm, top: 10mm, bottom: 10mm), // Increased margins for more professional look
    footer: [
      #set text(
        fill: color-accent, // Footer in accent color
        size: 7.5pt, // Slightly increased size
      )
      #__justify_align_3[
        #smallcaps[#date]
      ][
        #smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          CV
        ]
      ][
        #counter(page).display()
      ]
    ],
  )
  
  // set paragraph spacing
  set par(leading: 0.6em) // Better paragraph spacing
  
  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.2em, // Increased for better spacing
      below: 0.8em, // Increased for better spacing
    )
    #set text(
      size: 14pt,
      weight: "regular",
      fill: color-accent, // Full heading in dark blue
    )
    
    #align(left)[
      #text[#strong[#it.body]]
      #box(width: 1fr, line(length: 100%, stroke: color-accent)) // Line also in dark blue
    ]
  ]
  
  show heading.where(level: 2): it => {
    set text(
      color-middledarkgray,
      size: 11pt,
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 9pt,
      weight: "regular",
      fill: color-gray,
    )
    smallcaps[#it.body]
  }
  
  // Contents
  create-header(firstname: author.firstname,
                lastname: author.lastname,
                position: author.position,
                address: author.address,
                contacts: author.contacts,
                profile-photo: profile-photo,)
  body
}