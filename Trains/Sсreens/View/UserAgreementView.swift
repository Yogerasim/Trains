import SwiftUI

struct UserAgreementView: View {
    var onClose: (() -> Void)? = nil

    private let title = """
    Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум  для физических лиц
    """
    private let shortText = """
    Данный документ является действующим, если расположен по адресу: https:

    Российская Федерация, город Москва
    """
    private let title2 = """
        1. ТЕРМИНЫ
    """

    private let longText = """
    Понятия, используемые в Оферте, означают следующее:  Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.  Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
    """

    var body: some View {
        VStack(spacing: .zero) {
            NavigationTitleView(title: "Пользовательское соглашение") {
                onClose?()
            }

            ScrollView {
                VStack(spacing: 1) {
                    Text(title)
                        .font(DesignSystem.Fonts.bold19)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                    Text(shortText)
                        .font(DesignSystem.Fonts.regular17)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Text(title2)
                        .font(DesignSystem.Fonts.bold19)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(longText)
                        .font(DesignSystem.Fonts.regular17)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    UserAgreementView()
}
