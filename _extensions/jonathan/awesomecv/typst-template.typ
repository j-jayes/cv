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

// Parse icon string - using try-catch-like approach
#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") {
    let parts = icon_string.split(" ")
    if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-darknight)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), fa-set: "Brands", fill: color-darknight)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  } else if icon_string.ends-with(".svg") {
    box(image(icon_string))
  } else {
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

// Parse markdown-style links [text](url) into typst links
#let parse_links(text) = {
  // If text is not a string, return it unchanged
  if type(text) != "string" {
    return text
  }

  // If no link characters, return immediately
  if not text.contains("[") or not text.contains("](") {
    return text
  }

  // Use a regular expression-like approach with string operations
  let parts = ()
  let rest = text
  let result = ""
  
  // Find markdown links of the format [text](url)
  while rest.contains("[") and rest.contains("](") and rest.contains(")") {
    // Find opening bracket
    let start_idx = rest.position("[")
    
    // Text before the link
    let prefix = rest.slice(0, start_idx)
    result += prefix
    
    // Look for matching closing pattern
    let bracket_count = 1
    let link_text_start = start_idx + 1
    let link_text_end = none
    let looking_for_text = true
    let url_start = none
    let url_end = none
    
    // Process character by character
    for i in range(link_text_start, rest.len()) {
      let char = rest.at(i)
      
      if looking_for_text {
        // Looking for link text portion
        if char == "[" {
          bracket_count += 1
        } else if char == "]" {
          bracket_count -= 1
          if bracket_count == 0 and i + 1 < rest.len() and rest.at(i + 1) == "(" {
            link_text_end = i
            url_start = i + 2  // Skip "]("
            looking_for_text = false
          }
        }
      } else {
        // Looking for URL portion
        if char == "(" {
          bracket_count += 1
        } else if char == ")" {
          bracket_count -= 1
          if bracket_count == 0 {
            url_end = i
            break
          }
        }
      }
    }
    
    // If we found a complete link pattern
    if link_text_end != none and url_end != none {
      let link_text = rest.slice(link_text_start, link_text_end)
      let url = rest.slice(url_start, url_end)
      
      // Now we just add the text without a link since you requested no hyperlinks
      result += link_text
      
      // Update rest to continue processing
      rest = rest.slice(url_end + 1)
    } else {
      // No properly formatted link found, include the opening bracket and continue
      result += "["
      rest = rest.slice(start_idx + 1)
    }
  }
  
  // Add any remaining text
  result += rest
  return result
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block(spacing: 0.3em)[
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
    size: 10pt, // Increased font size
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
    size: 9pt, // Increased font size
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
    above: 0.7em, // Increased spacing above
    below: 0.1em, // Kept reduced spacing below
  )
  __justify_align[
    #set text(
      size: 12pt, // Increased size further
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
      size: 11pt, // Increased size further
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
  
  pad(bottom: 2pt)[
    #block[
      #set text(
        size: 26pt, // Reduced size
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
      above: 0.3em, // Reduced spacing
      below: 0.3em, // Reduced spacing
    )
  
  set text(
    color-accent, // Dark blue as per request
    size: 10pt, // Increased font size
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
      above: 0.2em, // Reduced spacing
      below: 0.2em, // Reduced spacing
  )
  set text(
    color-lightgray,
    size: 9pt, // Increased font size
    style: "italic",
  )

  block[#address]
}

#let create-header-contacts(
  contacts: (),
) = {
  let separator = box(width: 2pt)
  if contacts != none and contacts.len() > 0 {
    block[
      #set text(
        size: 9pt, // Increased font size
        weight: "regular",
        style: "normal",
      )
      #align(horizon)[
        #for (i, contact) in contacts.enumerate() [
          #set box(height: 9pt) // Increased height
          #box[#parse_icon_string(contact.icon) #link(contact.url)[#contact.text]]
          #if i < contacts.len() - 1 [#separator]
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
// New Resume Entries - Formatted like the example
//------------------------------------------------------------------------------

#let resume-item(body) = {
  set text(
    size: 10pt, // Increased size to match base
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.7em, justify: true) // Increased paragraph spacing
  set list(indent: 0.8em, spacing: 0.5em) // Increased list spacing
  body
}

// New experience entry format based on your example
#let resume-entry(
  company_name: "",
  location: "", 
  title: "",
  date: "",
  description: "",
  bullets: (),
) = {
  block(spacing: 0em, below: 1.2em)[  // Increased spacing below each entry
    // Company name bold at the top left, location bold at top right
    #justified-header(
      [#company_name],
      [#location]
    )
    
    // Added space after company name
    #v(0.2em)
    
    // Job title in italics on left, date on right
    #secondary-justified-header(
      [#title],
      [#date]
    )
    
    // Added space after title
    #v(0.3em)
    
    // Description with consistent text styling
    #if description != "" [
      #block(above: 0.3em, below: 0.4em)[  // Increased spacing around description
        #set text(
          size: 10pt, // Increased size to match base
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #parse_links(parse_italics(description))
      ]
    ]
    
    // Bullet points if provided
    #if bullets != none and bullets.len() > 0 [
      #block(above: 0.3em)[  // Increased padding before bullet points
        #set text(
          size: 8.5pt, // Further reduced bullet point size
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #set par(leading: 0.55em, justify: true) // Justified bullet points text
        #list(
          ..bullets.map(item => parse_links(parse_italics(item))),
          indent: 0.7em,
          spacing: 0.3em // Reduced bullet point spacing
        )
      ]
    ]
  ]
}

// New education entry format matching the experience entry
#let education-entry(
  degree: "",
  institution: "",
  subheader: "",
  date: "",
  bullets: (),
) = {
  block(spacing: 0em, below: 1.2em)[  // Increased spacing below each entry
    // Degree name bold at the top left, institution bold at top right
    #justified-header(
      [#degree],
      [#institution]
    )
    
    // Added space after degree
    #v(0.2em)
    
    // Subheader on left, date on right
    #secondary-justified-header(
      [#subheader],
      [#date]
    )
    
    // Added space after subheader
    #v(0.3em)
    
    // Bullet points if provided
    #if bullets != none and bullets.len() > 0 [
      #block(above: 0.4em)[  // Increased padding before bullet points
        #set text(
          size: 8.5pt, // Further reduced bullet point size
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #set par(leading: 0.55em, justify: true) // Justified bullet points text
        #list(
          ..bullets.map(item => parse_links(parse_italics(item))),
          indent: 0.7em,
          spacing: 0.3em // Reduced bullet point spacing
        )
      ]
    ]
  ]
}

// For Skills section (kept the same as you had it)
#let skills-entry(
  title: none,
  description: "",
  bullets: (),
) = {
  block(spacing: 0em, below: 0.6em)[  // Adjusted spacing for skills entries
    // Skills title in italics
    #block(below: 0.3em)[
      #set text(
        size: 11pt, // Increased font size
        style: "italic",
        weight: "regular",
        fill: color-darkgray,
      )
      #title
    ]
    
    // Description with consistent text styling
    #if description != "" [
      #block(above: 0.2em, below: 0.3em)[
        #set text(
          size: 10pt, // Increased to match base
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #parse_links(parse_italics(description))
      ]
    ]
    
    // Added bullet points support
    #if bullets != none and bullets.len() > 0 [
      #block(above: 0.3em)[
        #set text(
          size: 8.5pt, // Same size as base font
          style: "normal",
          weight: "regular",
          fill: color-darknight,
        )
        #set par(leading: 0.7em, justify: true) // Consistent with other bullet points
        #list(
          ..bullets.map(item => parse_links(parse_italics(item))),
          indent: 0.8em,
          spacing: 0.5em // Same spacing as other bullet points
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
    size: 10pt, // Increased base font size from 9pt to 10pt
    fill: color-darkgray,
    fallback: true,
  )
  
  set par(
    leading: 0.7em, // Increased paragraph spacing
    justify: true    // Justify all text
  )
  
  set page(
    paper: "a4",
    margin: (left: 16mm, right: 16mm, top: 8mm, bottom: 8mm), // Reduced margins
    footer: [
      #set text(
        fill: color-accent, // Footer in accent color
        size: 7pt, // Reduced size
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
  
  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.4em, // Further increased spacing above section headings
      below: 0.8em, // Increased spacing below section headings
    )
    #set text(
      size: 15pt, // Increased size further
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
      size: 10pt, // Reduced size
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 8pt, // Reduced size
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