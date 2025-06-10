import SwiftUI

struct QuestionView: View {
  //MARK: - FAQ Data
  @State private var faqItems: [FAQ] = [
    FAQ(question: "How long will it take for my order to arrive?", answer: "Orders placed via Standard shipping will be processed within 2-8 business days and will be in transit for 1-5 days. Orders placed via Expedited shipping will be processed within 1-2 business days and will be in transit for 1-5 days."),
    FAQ(question: "Where do you ship?", answer: "We ship to all 63 provinces in the Vietnam."),
    FAQ(question: "If I order more than one plant, will they ship separately?", answer: "Yes, each individual plant ships separately. Plants that are part of the same order may ship out on different days and may also be delivered on different days. You will receive individual tracking information for each plant in your order."),
    FAQ(question: "How do I order several plants to go to different addresses?", answer: "If you're hoping to purchase 5 or more plants going to different addresses, our Customer Support team can help with that! Just with details about your bulk order and someone on our team will get back to you as soon as possible."),
    FAQ(question: "What if I need to cancel my order?", answer: "We begin work on each order soon after it is placed. To cancel an order, you must within 12 hours of your order being placed and we will process a refund at our discretion. After that, it is not possible to cancel your order. We are unable to cancel or make any changes to orders after they have shipped.")
  ]
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        ForEach($faqItems) { $item in
          FAQRow(item: $item)
        }
      }
      .padding(.horizontal, 48)
    }
    .inlineNavigation(title: "FAQS", isShow: false)
  }
}

//MARK: - FAQROW View
struct FAQRow: View {
  @Binding var item: FAQ
  
  var body: some View {
    VStack(alignment: .leading) {
      Button {
        withAnimation(.spring) { item.isExpanded.toggle() }
      } label: {
        HStack {
          Text(item.question)
            .sub(type: .regular)
            .multilineTextAlignment(.leading)
            .frame(width: 245, alignment: .leading)
          Spacer()
          Image(.chevronDown)
            .rotationEffect(item.isExpanded ? Angle(degrees: 180) : .zero)
        }
        .foregroundStyle(.black)
        .padding(.vertical, 15)
      }
      
      if item.isExpanded {
        Text(item.answer)
          .body(type: .regular)
          .foregroundStyle(.appLightGray)
      }
    }
  }
}

//MARK: - FAQ Model
struct FAQ: Identifiable {
  let id = UUID()
  let question: String
  let answer: String
  var isExpanded = false
}

//MARK: - Preview
#Preview {
  QuestionView()
    .previewRouter()
}
